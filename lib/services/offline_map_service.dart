import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Service for managing offline map tile storage and retrieval
class OfflineMapService {
  static final OfflineMapService _instance = OfflineMapService._internal();
  factory OfflineMapService() => _instance;
  OfflineMapService._internal();

  Database? _database;
  Directory? _cacheDirectory;
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
    maxRedirects: 5,
  ));

  // Configuration
  static const int maxCacheSizeBytes = 500 * 1024 * 1024; // 500MB default
  static const int maxInMemoryCacheSize = 100;
  
  // In-memory cache for frequently accessed tiles
  final Map<String, Uint8List> _memoryCache = {};
  final List<String> _memoryCacheKeys = [];
  
  // Track ongoing network requests to prevent duplicates
  final Map<String, Completer<Uint8List?>> _pendingRequests = {};

  /// Initialize the offline map service
  Future<void> initialize() async {
    if (_database != null) return; // Already initialized

    try {
      // Get application documents directory
      final appDir = await getApplicationDocumentsDirectory();
      _cacheDirectory = Directory('${appDir.path}/map_tiles');
      
      // Create cache directory if it doesn't exist
      if (!await _cacheDirectory!.exists()) {
        await _cacheDirectory!.create(recursive: true);
      }

      // Initialize database
      final dbPath = '${appDir.path}/map_tiles.db';
      _database = await openDatabase(
        dbPath,
        version: 1,
        onCreate: _createDatabase,
      );

      if (kDebugMode) {
        print('OfflineMapService initialized successfully');
        print('Cache directory: ${_cacheDirectory!.path}');
        print('Database path: $dbPath');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing OfflineMapService: $e');
      }
      rethrow;
    }
  }

  /// Create database schema
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE map_tiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url TEXT NOT NULL UNIQUE,
        x INTEGER NOT NULL,
        y INTEGER NOT NULL,
        z INTEGER NOT NULL,
        file_path TEXT NOT NULL,
        size_bytes INTEGER NOT NULL,
        access_count INTEGER DEFAULT 1,
        last_accessed INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    // Create index for faster lookups
    await db.execute('CREATE INDEX idx_tile_coords ON map_tiles(x, y, z)');
    await db.execute('CREATE INDEX idx_last_accessed ON map_tiles(last_accessed)');
  }

  /// Generate unique file name for tile based on URL hash
  String _getTileFileName(String url) {
    final bytes = utf8.encode(url);
    final hash = md5.convert(bytes);
    return '$hash.tile';
  }

  /// Get tile from cache or network
  Future<Uint8List?> getTile(String url, int x, int y, int z) async {
    await initialize();

    final cacheKey = '$z-$x-$y';

    // Check in-memory cache first
    if (_memoryCache.containsKey(cacheKey)) {
      if (kDebugMode) {
        print('Tile found in memory cache: $cacheKey');
      }
      _updateMemoryCacheAccess(cacheKey);
      return _memoryCache[cacheKey];
    }

    // Check if there's already a pending request for this tile
    if (_pendingRequests.containsKey(cacheKey)) {
      if (kDebugMode) {
        print('Waiting for pending request: $cacheKey');
      }
      return await _pendingRequests[cacheKey]!.future;
    }

    // Check database cache
    try {
      final cachedTile = await _getTileFromDatabase(url);
      if (cachedTile != null) {
        // Update access tracking
        await _updateTileAccess(url);
        
        // Add to memory cache
        _addToMemoryCache(cacheKey, cachedTile);
        
        return cachedTile;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error reading from cache: $e');
      }
    }

    // Fetch from network
    return await _fetchTileFromNetwork(url, x, y, z, cacheKey);
  }

  /// Get tile from database cache
  Future<Uint8List?> _getTileFromDatabase(String url) async {
    final result = await _database!.query(
      'map_tiles',
      where: 'url = ?',
      whereArgs: [url],
      limit: 1,
    );

    if (result.isEmpty) return null;

    final filePath = result.first['file_path'] as String;
    final file = File(filePath);

    if (!await file.exists()) {
      // File missing, remove from database
      await _database!.delete('map_tiles', where: 'url = ?', whereArgs: [url]);
      return null;
    }

    return await file.readAsBytes();
  }

  /// Fetch tile from network and cache it
  Future<Uint8List?> _fetchTileFromNetwork(
    String url,
    int x,
    int y,
    int z,
    String cacheKey,
  ) async {
    // Create completer for this request
    final completer = Completer<Uint8List?>();
    _pendingRequests[cacheKey] = completer;

    try {
      if (kDebugMode) {
        print('Fetching tile from network: $url');
      }

      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data != null) {
        final tileData = Uint8List.fromList(response.data!);
        
        // Save to cache asynchronously (don't await)
        _saveTileToCache(url, x, y, z, tileData).catchError((e) {
          if (kDebugMode) {
            print('Error saving tile to cache: $e');
          }
        });

        // Add to memory cache
        _addToMemoryCache(cacheKey, tileData);

        completer.complete(tileData);
        return tileData;
      } else {
        if (kDebugMode) {
          print('Failed to fetch tile: ${response.statusCode}');
        }
        completer.complete(null);
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching tile from network: $e');
      }
      completer.complete(null);
      return null;
    } finally {
      _pendingRequests.remove(cacheKey);
    }
  }

  /// Save tile to cache
  Future<void> _saveTileToCache(
    String url,
    int x,
    int y,
    int z,
    Uint8List data,
  ) async {
    try {
      final fileName = _getTileFileName(url);
      final filePath = '${_cacheDirectory!.path}/$fileName';
      final file = File(filePath);

      // Write tile data to file
      await file.writeAsBytes(data);

      final now = DateTime.now().millisecondsSinceEpoch;

      // Insert into database
      await _database!.insert(
        'map_tiles',
        {
          'url': url,
          'x': x,
          'y': y,
          'z': z,
          'file_path': filePath,
          'size_bytes': data.length,
          'access_count': 1,
          'last_accessed': now,
          'created_at': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Check cache size and evict if necessary
      await _evictOldTilesIfNeeded();
    } catch (e) {
      if (kDebugMode) {
        print('Error saving tile to cache: $e');
      }
    }
  }

  /// Update tile access tracking
  Future<void> _updateTileAccess(String url) async {
    await _database!.rawUpdate(
      '''
      UPDATE map_tiles 
      SET access_count = access_count + 1,
          last_accessed = ? 
      WHERE url = ?
      ''',
      [DateTime.now().millisecondsSinceEpoch, url],
    );
  }

  /// Add tile to in-memory cache
  void _addToMemoryCache(String key, Uint8List data) {
    if (_memoryCache.containsKey(key)) {
      _memoryCacheKeys.remove(key);
    }

    _memoryCache[key] = data;
    _memoryCacheKeys.add(key);

    // Evict oldest if cache is full
    while (_memoryCacheKeys.length > maxInMemoryCacheSize) {
      final oldestKey = _memoryCacheKeys.removeAt(0);
      _memoryCache.remove(oldestKey);
    }
  }

  /// Update memory cache access (move to end)
  void _updateMemoryCacheAccess(String key) {
    _memoryCacheKeys.remove(key);
    _memoryCacheKeys.add(key);
  }

  /// Check cache size and evict old tiles if needed
  Future<void> _evictOldTilesIfNeeded() async {
    final cacheSize = await getCacheSize();
    
    if (cacheSize > maxCacheSizeBytes) {
      await evictOldTiles(maxCacheSizeBytes);
    }
  }

  /// Evict old tiles using LRU policy
  Future<void> evictOldTiles(int targetSizeBytes) async {
    try {
      // Get tiles ordered by last access (oldest first)
      final tiles = await _database!.query(
        'map_tiles',
        orderBy: 'last_accessed ASC',
      );

      int currentSize = 0;
      for (final tile in tiles) {
        currentSize += tile['size_bytes'] as int;
      }

      // Delete tiles until we're under the target size
      for (final tile in tiles) {
        if (currentSize <= targetSizeBytes) break;

        final filePath = tile['file_path'] as String;
        final file = File(filePath);
        
        if (await file.exists()) {
          await file.delete();
        }

        await _database!.delete(
          'map_tiles',
          where: 'id = ?',
          whereArgs: [tile['id']],
        );

        currentSize -= tile['size_bytes'] as int;

        if (kDebugMode) {
          print('Evicted tile: ${tile['url']}');
        }
      }

      if (kDebugMode) {
        print('Cache eviction complete. New size: $currentSize bytes');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error evicting tiles: $e');
      }
    }
  }

  /// Get current cache size in bytes
  Future<int> getCacheSize() async {
    final result = await _database!.rawQuery(
      'SELECT SUM(size_bytes) as total FROM map_tiles',
    );
    
    return (result.first['total'] as int?) ?? 0;
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    final size = await getCacheSize();
    final count = Sqflite.firstIntValue(
      await _database!.rawQuery('SELECT COUNT(*) FROM map_tiles'),
    ) ?? 0;

    return {
      'totalSizeBytes': size,
      'totalTiles': count,
      'memoryCachedTiles': _memoryCache.length,
    };
  }

  /// Clear all cached tiles
  Future<void> clearCache() async {
    await initialize();

    try {
      // Delete all files
      if (await _cacheDirectory!.exists()) {
        await _cacheDirectory!.delete(recursive: true);
        await _cacheDirectory!.create();
      }

      // Clear database
      await _database!.delete('map_tiles');

      // Clear memory cache
      _memoryCache.clear();
      _memoryCacheKeys.clear();

      if (kDebugMode) {
        print('Cache cleared successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing cache: $e');
      }
    }
  }

  /// Download multiple tiles (used by area downloader)
  Future<void> downloadTiles(
    List<Map<String, dynamic>> tiles,
    Function(int current, int total)? onProgress,
  ) async {
    await initialize();

    int completed = 0;
    final total = tiles.length;

    for (final tile in tiles) {
      try {
        await getTile(
          tile['url'] as String,
          tile['x'] as int,
          tile['y'] as int,
          tile['z'] as int,
        );
        
        completed++;
        onProgress?.call(completed, total);
      } catch (e) {
        if (kDebugMode) {
          print('Error downloading tile: $e');
        }
      }
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _database?.close();
    _database = null;
    _memoryCache.clear();
    _memoryCacheKeys.clear();
    _dio.close();
  }
}
