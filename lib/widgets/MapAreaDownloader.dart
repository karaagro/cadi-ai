import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cadi_ai/services/offline_map_service.dart';
import 'package:cadi_ai/services/offline_tile_provider.dart';
import 'package:cadi_ai/utils/tile_calculator.dart';
import 'dart:math' as math;

/// Widget for downloading map tiles for offline use
class MapAreaDownloader extends StatefulWidget {
  final LatLng? initialCenter;
  final Function(String message)? onStatusUpdate;

  const MapAreaDownloader({
    Key? key,
    this.initialCenter,
    this.onStatusUpdate,
  }) : super(key: key);

  @override
  State<MapAreaDownloader> createState() => _MapAreaDownloaderState();
}

class _MapAreaDownloaderState extends State<MapAreaDownloader> {
  final MapController _mapController = MapController();
  final OfflineMapService _offlineMapService = OfflineMapService();

  // Radius-based selection (only mode now)
  LatLng? _centerPoint;
  double _radiusKm = 5.0; // Default 5km radius
  
  // Download state
  bool _isDownloading = false;
  bool _isPaused = false;
  int _downloadedTiles = 0;
  int _totalTiles = 0;
  int _failedTiles = 0;
  DateTime? _downloadStartTime;
  
  // Zoom level selection
  final List<int> _selectedZoomLevels = [13, 14, 15];
  final List<int> _availableZoomLevels = List.generate(10, (i) => i + 10); // 10-19
  
  // Quality presets
  String _selectedQuality = 'medium';
  
  // Map type
  int _mapType = 0;
  
  @override
  void initState() {
    super.initState();
    _initializeService();
    // Set initial center point
    _centerPoint = widget.initialCenter ?? const LatLng(0, 0);
  }

  Future<void> _initializeService() async {
    await _offlineMapService.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Map Area'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showHelp,
          ),
        ],
      ),
      body: Column(
        children: [
          // Map view with selection
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                _buildMap(),
                _buildSelectionOverlay(),
                _buildMapControls(),
              ],
            ),
          ),
          
          // Download controls
          Expanded(
            flex: 2,
            child: _isDownloading
                ? _buildDownloadProgress()
                : _buildDownloadConfig(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: widget.initialCenter ?? const LatLng(0, 0),
        initialZoom: 13.0,
        minZoom: 10.0,
        maxZoom: 19.0,
      ),
      children: [
        TileLayer(
          tileProvider: OfflineTileProvider(
            urlTemplate: _getMapUrlTemplate(),
          ),
        ),
        // Show radius circle
        if (_centerPoint != null)
          CircleLayer(
            circles: [
              CircleMarker(
                point: _centerPoint!,
                radius: _radiusKm * 1000, // Convert km to meters
                color: Colors.blue.withOpacity(0.2),
                borderColor: Colors.blue,
                borderStrokeWidth: 2.0,
                useRadiusInMeter: true, // Use meter-based radius so it scales with zoom
              ),
            ],
          ),
        // Center marker
        if (_centerPoint != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _centerPoint!,
                width: 40,
                height: 40,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    // Allow dragging the center point
                    try {
                      final currentPoint = _mapController.camera.latLngToScreenPoint(_centerPoint!);
                      final newPoint = math.Point(
                        currentPoint.x + details.delta.dx,
                        currentPoint.y + details.delta.dy,
                      );
                      final newCenter = _mapController.camera.pointToLatLng(newPoint);
                      setState(() {
                        _centerPoint = newCenter;
                      });
                    } catch (e) {
                      // Map not ready, ignore
                    }
                  },
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.blue,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }



  Widget _buildSelectionOverlay() {
    if (_isDownloading) return const SizedBox.shrink();
    
    return Positioned(
      top: 16,
      left: 60,
      right: 60,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Drag the marker to reposition • Use slider below to adjust radius',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Remove selectCurrentView - no longer needed
  // Remove _getSelectionPolygonPoints - no longer needed

  Widget _buildMapControls() {
    return Positioned(
      top: 16,
      right: 16,
      child: Column(
        children: [
          // Map type switch
          FloatingActionButton(
            mini: true,
            heroTag: 'maptype',
            backgroundColor: Colors.white,
            onPressed: () {
              setState(() {
                _mapType = _mapType == 0 ? 1 : 0;
              });
            },
            child: const Icon(Icons.layers, color: Colors.black),
          ),
          const SizedBox(height: 8),
          

        ],
      ),
    );
  }

  Widget _buildDownloadConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Radius slider
          Row(
            children: [
              const Text(
                'Radius:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '${_radiusKm.toStringAsFixed(1)} km',
                style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
            Slider(
              value: _radiusKm,
              min: 1.0,
              max: 50.0,
              divisions: 49,
              label: '${_radiusKm.toStringAsFixed(1)} km',
              onChanged: (value) {
                setState(() {
                  _radiusKm =value;
                });
              },
            ),
            const SizedBox(height: 8),
            // Preset radius buttons
            Wrap(
              spacing: 8,
              children: [
                _buildPresetButton('2 km', 2.0),
                _buildPresetButton('5 km', 5.0),
                _buildPresetButton('10 km', 10.0),
                _buildPresetButton('25 km', 25.0),
              ],
            ),
            const SizedBox(height: 16),
          
          // Quality presets
          const Text(
            'Download Quality',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildQualityChip('Low', 'low'),
              _buildQualityChip('Medium', 'medium'),
              _buildQualityChip('High', 'high'),
              _buildQualityChip('Custom', 'custom'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Zoom levels (show only if custom)
          if (_selectedQuality == 'custom') ...[
            const Text(
              'Zoom Levels',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _availableZoomLevels.map((zoom) {
                final isSelected = _selectedZoomLevels.contains(zoom);
                return FilterChip(
                  label: Text('$zoom'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedZoomLevels.add(zoom);
                        _selectedZoomLevels.sort();
                      } else {
                        _selectedZoomLevels.remove(zoom);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          
          // Download statistics
          if (_hasValidSelection()) ...[
            _buildDownloadStats(),
          ],
        ],
      ),
    );
  }

  Widget _buildPresetButton(String label, double radiusKm) {
    final isSelected = (_radiusKm - radiusKm).abs() < 0.1;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _radiusKm = radiusKm;
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey,
          width: isSelected ? 2 : 1,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(label),
    );
  }

  bool _hasValidSelection() {
    return _centerPoint != null;
  }

  Widget _buildQualityChip(String label, String value) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedQuality == value,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedQuality = value;
            if (value != 'custom') {
              _selectedZoomLevels.clear();
              _selectedZoomLevels.addAll(
                TileCalculator.getRecommendedZoomLevels(value),
              );
            }
          });
        }
      },
    );
  }

  Widget _buildDownloadStats() {
    if (_centerPoint == null) return const SizedBox.shrink();
    
    // Calculate bounds from radius
    final bounds = TileCalculator.getTileBounds(
      _centerPoint!.latitude,
      _centerPoint!.longitude,
      _radiusKm,
    );
    final northWest = bounds['northWest']!;
    final southEast = bounds['southEast']!;

    final tileCount = TileCalculator.calculateTileCount(
      northWest,
      southEast,
      _selectedZoomLevels,
    );
    final estimatedSize = TileCalculator.estimateDownloadSize(tileCount);
    final estimatedTime = TileCalculator.estimateDownloadTime(
      estimatedSize,
      100000, // ~100KB/s average
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Download Estimate',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildStatRow('Tiles', '$tileCount'),
          _buildStatRow(
            'Size',
            TileCalculator.formatBytes(estimatedSize),
          ),
          _buildStatRow(
            'Est. Time',
            TileCalculator.formatDuration(estimatedTime),
          ),
          _buildStatRow(
            'Zoom Levels',
            _selectedZoomLevels.join(', '),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  Widget _buildDownloadProgress() {
    final progress = _totalTiles > 0 ? _downloadedTiles / _totalTiles : 0.0;
    final elapsed = _downloadStartTime != null
        ? DateTime.now().difference(_downloadStartTime!)
        : Duration.zero;
    final speed = elapsed.inSeconds > 0
        ? _downloadedTiles / elapsed.inSeconds
        : 0.0;
    final remaining = speed > 0
        ? Duration(seconds: ((_totalTiles - _downloadedTiles) / speed).ceil())
        : Duration.zero;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isPaused ? 'Download Paused' : 'Downloading...',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          
          Text(
            '${(_downloadedTiles / _totalTiles * 100).toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          _buildStatRow('Downloaded', '$_downloadedTiles / $_totalTiles tiles'),
          _buildStatRow('Failed', '$_failedTiles tiles'),
          _buildStatRow('Speed', '${speed.toStringAsFixed(1)} tiles/s'),
          _buildStatRow('Remaining', TileCalculator.formatDuration(remaining)),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isPaused = !_isPaused;
                    });
                  },
                  icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  label: Text(_isPaused ? 'Resume' : 'Pause'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _cancelDownload,
                  icon: const Icon(Icons.stop),
                  label: const Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    if (_isDownloading) return const SizedBox.shrink();

    final canDownload = _hasValidSelection() && _selectedZoomLevels.isNotEmpty;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: canDownload ? _startDownload : null,
          icon: const Icon(Icons.download),
          label: const Text('Start Download'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ),
    );
  }

  List<LatLng> _getSelectionPolygonPoints() {
    // No longer needed but keep for compatibility
    return [];
  }

  Future<void> _startDownload() async {
    if (_centerPoint == null) return;

    setState(() {
      _isDownloading = true;
      _downloadedTiles = 0;
      _failedTiles = 0;
      _downloadStartTime = DateTime.now();
    });

    // Calculate bounds from radius
    final bounds = TileCalculator.getTileBounds(
      _centerPoint!.latitude,
      _centerPoint!.longitude,
      _radiusKm,
    );
    final northWest = bounds['northWest']!;
    final southEast = bounds['southEast']!;

    // Generate tile list
    final tiles = <Map<String, dynamic>>[];
    for (final zoom in _selectedZoomLevels) {
      final tileCoordslist = TileCalculator.getTilesInBounds(
        northWest,
        southEast,
        zoom,
      );
      
      for (final tileCoords in tileCoordslist) {
        final url = _generateTileUrl(tileCoords.x, tileCoords.y, zoom);
        tiles.add({
          'url': url,
          'x': tileCoords.x,
          'y': tileCoords.y,
          'z': zoom,
        });
      }
    }

    setState(() {
      _totalTiles = tiles.length;
    });

    // Download tiles
    try {
      await _offlineMapService.downloadTiles(
        tiles,
        (current, total) {
          if (!_isPaused && mounted) {
            setState(() {
              _downloadedTiles = current;
            });
          }
        },
      );

      if (mounted) {
        widget.onStatusUpdate?.call('Download completed successfully!');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        widget.onStatusUpdate?.call('Download failed: $e');
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  void _cancelDownload() {
    setState(() {
      _isDownloading = false;
      _isPaused = false;
      _downloadedTiles = 0;
      _totalTiles = 0;
      _failedTiles = 0;
    });
  }

  String _getMapUrlTemplate() {
    return {
      0: 'https://api.mapbox.com/styles/v1/drewthejedi/cl7ht68dw003h14p5mdx4xnia/tiles/512/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZHJld3RoZWplZGkiLCJhIjoiY2w3aHRla20zMGh1MDN1c2FpcTBkZzNxbyJ9._phchIP2mPwilN7P-fmd7w',
      1: 'https://www.google.com/maps/vt/pb=!1m4!1m3!1i{z}!2i{x}!3i{y}!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425'
    }[_mapType]!;
  }

  String _generateTileUrl(int x, int y, int z) {
    return _getMapUrlTemplate()
        .replaceAll('{z}', z.toString())
        .replaceAll('{x}', x.toString())
        .replaceAll('{y}', y.toString());
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Download Maps'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '1. Drag the blue marker to position the center of your download area',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 12),
              Text(
                '2. Adjust the radius using the slider (1-50 km)',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 12),
              Text(
                '3. Or use quick preset buttons: 2km, 5km, 10km, 25km',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 12),
              Text(
                '4. Choose quality level (Medium recommended)',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 12),
              Text(
                '5. Review the download estimate',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 12),
              Text(
                '6. Tap "Start Download"',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'Tips:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 8),
              Text(
                '• 5-10 km radius works well for most field work\n'
                '• Medium quality balances detail and storage\n'
                '• Larger radius = more storage needed\n'
                '• Downloaded maps work completely offline',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
