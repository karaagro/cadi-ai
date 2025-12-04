import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map/flutter_map.dart';
import 'offline_map_service.dart';

/// Custom tile provider that seamlessly switches between online and offline tiles
class OfflineTileProvider extends TileProvider {
  final String urlTemplate;
  final OfflineMapService _offlineMapService;
  
  @override
  final Map<String, String> headers;
  
  OfflineTileProvider({
    required this.urlTemplate,
    Map<String, String>? headers,
  }) : headers = headers ?? <String, String>{},
       _offlineMapService = OfflineMapService();
  
  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    return OfflineTileImageProvider(
      coordinates: coordinates,
      urlTemplate: urlTemplate,
      offlineMapService: _offlineMapService,
      headers: headers,
    );
  }
}

/// Custom image provider that handles offline/online tile loading
class OfflineTileImageProvider extends ImageProvider<OfflineTileImageProvider> {
  final TileCoordinates coordinates;
  final String urlTemplate;
  final OfflineMapService offlineMapService;
  final Map<String, String> headers;
  
  const OfflineTileImageProvider({
    required this.coordinates,
    required this.urlTemplate,
    required this.offlineMapService,
    required this.headers,
  });
  
  @override
  Future<OfflineTileImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<OfflineTileImageProvider>(this);
  }
  
  @override
  ImageStreamCompleter loadImage(OfflineTileImageProvider key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      debugLabel: 'OfflineTileImageProvider(${key.coordinates})',
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<OfflineTileImageProvider>('Image provider', this),
        DiagnosticsProperty<TileCoordinates>('Coordinates', key.coordinates),
      ],
    );
  }
  
  Future<ui.Codec> _loadAsync(OfflineTileImageProvider key, ImageDecoderCallback decode) async {
    try {
      // Generate tile URL
      final url = _generateTileUrl(key.coordinates);
      
      // Try to get tile from offline service (handles both cache and online download)
      final tileData = await key.offlineMapService.getTile(
        url,
        key.coordinates.x,
        key.coordinates.y,
        key.coordinates.z,
      );
      
      if (tileData != null && tileData.isNotEmpty) {
        final buffer = await ui.ImmutableBuffer.fromUint8List(tileData);
        return await decode(buffer);
      } else {
        // Try to get a lower zoom level tile as placeholder
        if (key.coordinates.z > 1) {
          final lowerZoomTile = await _tryGetLowerZoomTile(key, decode);
          if (lowerZoomTile != null) {
            return lowerZoomTile;
          }
        }
        
        // Return a simple placeholder if no data available
        return await _createPlaceholderTile(decode);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading tile ${key.coordinates}: $e');
      }
      return await _createErrorTile(decode);
    }
  }
  
  /// Try to get a tile from a lower zoom level as placeholder
  Future<ui.Codec?> _tryGetLowerZoomTile(
    OfflineTileImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    try {
      // Try one zoom level lower
      final lowerZ = key.coordinates.z - 1;
      final lowerX = key.coordinates.x ~/ 2;
      final lowerY = key.coordinates.y ~/ 2;
      
      final lowerUrl = urlTemplate
          .replaceAll('{z}', lowerZ.toString())
          .replaceAll('{x}', lowerX.toString())
          .replaceAll('{y}', lowerY.toString());
      
      final lowerTileData = await offlineMapService.getTile(
        lowerUrl,
        lowerX,
        lowerY,
        lowerZ,
      );
      
      if (lowerTileData != null && lowerTileData.isNotEmpty) {
        final buffer = await ui.ImmutableBuffer.fromUint8List(lowerTileData);
        return await decode(buffer);
      }
    } catch (e) {
      // Ignore errors, will use placeholder instead
    }
    return null;
  }
  
  String _generateTileUrl(TileCoordinates coordinates) {
    return urlTemplate
        .replaceAll('{z}', coordinates.z.toString())
        .replaceAll('{x}', coordinates.x.toString())
        .replaceAll('{y}', coordinates.y.toString());
  }
  
  Future<ui.Codec> _createPlaceholderTile(ImageDecoderCallback decode) async {
    // Create a simple gray placeholder tile (256x256)
    final bytes = Uint8List(256 * 256 * 4); // RGBA
    for (int i = 0; i < bytes.length; i += 4) {
      bytes[i] = 240;     // R
      bytes[i + 1] = 240; // G
      bytes[i + 2] = 240; // B
      bytes[i + 3] = 100; // A (semi-transparent)
    }
    
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    return await decode(buffer);
  }
  
  Future<ui.Codec> _createErrorTile(ImageDecoderCallback decode) async {
    // Create a red error tile (256x256)
    final bytes = Uint8List(256 * 256 * 4); // RGBA
    for (int i = 0; i < bytes.length; i += 4) {
      bytes[i] = 255;     // R
      bytes[i + 1] = 100; // G
      bytes[i + 2] = 100; // B
      bytes[i + 3] = 150; // A
    }
    
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    return await decode(buffer);
  }
  
  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is OfflineTileImageProvider &&
        other.coordinates == coordinates &&
        other.urlTemplate == urlTemplate;
  }
  
  @override
  int get hashCode => Object.hash(coordinates, urlTemplate);
  
  @override
  String toString() => '${objectRuntimeType(this, 'OfflineTileImageProvider')}("$urlTemplate", $coordinates)';
}