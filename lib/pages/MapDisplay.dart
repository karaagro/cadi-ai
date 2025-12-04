import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:cadi_ai/controllers/MainController.dart';
import 'package:cadi_ai/services/offline_tile_provider.dart';
import 'package:cadi_ai/services/offline_map_service.dart';
import 'package:cadi_ai/widgets/MapAreaDownloader.dart';

class MapDisplay extends StatefulWidget {
  const MapDisplay({
    Key? key,
  }) : super(key: key);

  @override
  MapDisplayState createState() => MapDisplayState();
}

class MapDisplayState extends State<MapDisplay> {
  int mapType = 0;
  final double _maxZoom = 50.0;
  final double _minZoom = 1.0;
  final mainController = Get.find<MainController>();
  final OfflineMapService _offlineMapService = OfflineMapService();

  MapDisplayState({Key? key});

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeOfflineService();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mainController.appState.allScansLatLong.listen((_) {
        setState(() {});
      });
      // Listen to selectedScanImageIndex changes to update marker highlighting
      mainController.appState.selectedScanImageIndex.listen((_) {
        setState(() {});
      });
    });
  }
  
  Future<void> _initializeOfflineService() async {
    await _offlineMapService.initialize();
    await _loadCacheStats();
    
    // Refresh cache stats every 30 seconds
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _loadCacheStats();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<String, dynamic> _cacheStats = {};
  
  Future<void> _loadCacheStats() async {
    try {
      final stats = await _offlineMapService.getCacheStats();
      if (mounted) {
        setState(() {
          _cacheStats = stats;
        });
      }
    } catch (e) {
      // Ignore errors
    }
  }

  void _gotoDefault() {
    try {
      final center = mainController.appState.allScansLatLong.isNotEmpty
          ? mainController.appState.allScansLatLong[0]
          : mainController.appState.defaultLocation;
      
      // Check if map controller is ready before using it
      if (mainController.appState.mapController.camera != null) {
        mainController.appState.mapController.move(center, 15.0);
      }
    } catch (e) {
      // Map controller not ready yet, ignore
      print('Map controller not ready: $e');
    }
  }

  String getMapUrlTemplate() {
    return {
      0: 'https://api.mapbox.com/styles/v1/drewthejedi/cl7ht68dw003h14p5mdx4xnia/tiles/512/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZHJld3RoZWplZGkiLCJhIjoiY2w3aHRla20zMGh1MDN1c2FpcTBkZzNxbyJ9._phchIP2mPwilN7P-fmd7w',
      1: 'https://www.google.com/maps/vt/pb=!1m4!1m3!1i{z}!2i{x}!3i{y}!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425'
    }[mapType]!;
  }

  void onZoomIn() {
    try {
      if (mainController.appState.mapController.camera != null) {
        final currentZoom = mainController.appState.mapController.camera.zoom;
        if (currentZoom < _maxZoom) {
          final center = mainController.appState.mapController.camera.center;
          mainController.appState.mapController.move(center, currentZoom + 1.0);
        }
      }
    } catch (e) {
      print('Zoom in failed: $e');
    }
  }

  void onZoomOut() {
    try {
      if (mainController.appState.mapController.camera != null) {
        final currentZoom = mainController.appState.mapController.camera.zoom;
        if (currentZoom > _minZoom) {
          final center = mainController.appState.mapController.camera.center;
          mainController.appState.mapController.move(center, currentZoom - 1.0);
        }
      }
    } catch (e) {
      print('Zoom out failed: $e');
    }
  }

  void onSwitchMapType() {
    setState(() {
      mapType = mapType == 0 ? 1 : 0;
    });
  }

  void _openMapDownloader() {
    LatLng? initialCenter;
    try {
      if (mainController.appState.mapController.camera != null) {
        initialCenter = mainController.appState.mapController.camera.center;
      }
    } catch (e) {
      // Use default location if map controller not ready
      initialCenter = null;
    }
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapAreaDownloader(
          initialCenter: initialCenter,
          onStatusUpdate: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
            // Refresh cache stats after download
            _loadCacheStats();
          },
        ),
      ),
    ).then((_) => _loadCacheStats());
  }

  void _showCacheStats() {
    final totalTiles = _cacheStats['totalTiles'] ?? 0;
    final totalSize = _cacheStats['totalSizeBytes'] ?? 0;
    final memoryCached = _cacheStats['memoryCachedTiles'] ?? 0;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Offline Cache Stats'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Cached Tiles'),
              trailing: Text('$totalTiles'),
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Storage Used'),
              trailing: Text(_formatBytes(totalSize)),
            ),
            ListTile(
              leading: const Icon(Icons.memory),
              title: const Text('In Memory'),
              trailing: Text('$memoryCached tiles'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Cache'),
                  content: const Text('Are you sure you want to delete all cached map tiles?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
              
              if (confirm == true && mounted) {
                await _offlineMapService.clearCache();
                await _loadCacheStats();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared successfully')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear Cache'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  Offset _calculateMarkerOffset(int index, List<LatLng> scanLocations) {
    // Calculate a small offset for clustered markers to make them distinguishable
    const double offsetDistance = 0.0001; // Very small offset in degrees
    const int maxMarkersPerRing = 8;
    
    // Find how many markers are very close to this one
    final currentLocation = scanLocations[index];
    int nearbyCount = 0;
    int positionInCluster = 0;
    
    for (int i = 0; i < scanLocations.length; i++) {
      if (i == index) {
        positionInCluster = nearbyCount;
        continue;
      }
      
      final other = scanLocations[i];
      final distance = sqrt(pow(currentLocation.latitude - other.latitude, 2) + 
                           pow(currentLocation.longitude - other.longitude, 2));
      
      if (distance < 0.001) { // Very close markers (within ~100m)
        if (i < index) nearbyCount++;
      }
    }
    
    if (nearbyCount == 0) {
      return const Offset(0, 0); // No offset needed
    }
    
    // Calculate circular offset based on position in cluster
    final angle = (positionInCluster * 2 * pi) / maxMarkersPerRing;
    final dx = offsetDistance * cos(angle);
    final dy = offsetDistance * sin(angle);
    
    return Offset(dx, dy);
  }

  List<Marker> _buildMarkers() {
    try {
      // Create a safe copy of the list to avoid modification issues
      final scanLocations = List<LatLng>.from(mainController.appState.allScansLatLong);
      final selectedIndex = mainController.appState.selectedScanImageIndex.value;
      
      print('Building markers: selectedIndex=$selectedIndex, total locations=${scanLocations.length}');
      
      return scanLocations.asMap().entries.map((entry) {
        final index = entry.key;
        final latLng = entry.value;
        final isSelected = selectedIndex == index;
        
        print('Marker $index: isSelected=$isSelected (selectedIndex=$selectedIndex)');
        
        // Add slight offset for clustered markers to make them more distinguishable
        final offset = _calculateMarkerOffset(index, scanLocations);
        
        return Marker(
          point: LatLng(latLng.latitude + offset.dx, latLng.longitude + offset.dy),
          width: 48,
          height: 48,
          child: GestureDetector(
            onTap: () {
              final lat = latLng.latitude.toString().substring(0, min(8, latLng.latitude.toString().length));
              final lng = latLng.longitude.toString().substring(0, min(8, latLng.longitude.toString().length));
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Text('Lat: $lat, Long: $lng'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: Icon(
              Icons.location_on,
              color: isSelected ? Colors.red : Colors.blue,
              size: 32,
            ),
          ),
        );
      }).toList();
    } catch (e) {
      print('Error building markers: $e');
      return <Marker>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FlutterMap(
          mapController: mainController.appState.mapController,
          options: MapOptions(
            initialCenter: mainController.appState.allScansLatLong.isNotEmpty
                ? mainController.appState.allScansLatLong.first
                : mainController.appState.defaultLocation,
            initialZoom: 15.0,
            minZoom: _minZoom,
            maxZoom: _maxZoom,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              tileProvider: OfflineTileProvider(
                urlTemplate: getMapUrlTemplate(),
              ),
            ),
            MarkerLayer(
              markers: _buildMarkers(),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Column(
                children: [
                  // Cache stats button
                  FloatingActionButton(
                    heroTag: 'stats',
                    mini: true,
                    backgroundColor: Colors.blue[700],
                    onPressed: _showCacheStats,
                    child: const Icon(Icons.storage, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  // Download button
                  FloatingActionButton(
                    heroTag: 'download',
                    mini: true,
                    backgroundColor: Colors.green[700],
                    onPressed: _openMapDownloader,
                    child: const Icon(Icons.download, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  // Map type switch button
                  FloatingActionButton(
                    heroTag: 'maptype',
                    mini: true,
                    backgroundColor: Colors.white70,
                    onPressed: onSwitchMapType,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/satellite_map.jpeg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Zoom controls
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: onZoomIn,
                          icon: const Icon(Icons.add, color: Colors.black),
                        ),
                        IconButton(
                          onPressed: onZoomOut,
                          icon: const Icon(Icons.remove, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white70,
        onPressed: _gotoDefault,
        tooltip: 'My Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
