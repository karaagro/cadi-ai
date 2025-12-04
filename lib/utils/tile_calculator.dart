import 'dart:math' as math;
import 'package:latlong2/latlong.dart';

/// Utility class for map tile calculations and conversions
class TileCalculator {
  /// Average size of a map tile in bytes (estimated for compressed images)
  static const int avgTileSizeBytes = 15000; // ~15KB average for WebP compressed tiles
  
  /// Hyperbolic sine function (for older Dart versions that don't have it)
  static double _sinh(double x) {
    return (math.exp(x) - math.exp(-x)) / 2.0;
  }
  
  /// Convert latitude/longitude to tile coordinates at given zoom level
  static math.Point<int> latLngToTile(double lat, double lng, int zoom) {
    final n = math.pow(2, zoom).toDouble();
    final x = ((lng + 180.0) / 360.0 * n).floor();
    final latRad = lat * math.pi / 180.0;
    final y = ((1.0 - math.log(math.tan(latRad) + 1.0 / math.cos(latRad)) / math.pi) / 2.0 * n).floor();
    return math.Point(x, y);
  }
  
  /// Convert tile coordinates to latitude/longitude
  static LatLng tileToLatLng(int x, int y, int zoom) {
    final n = math.pow(2, zoom).toDouble();
    final lng = x / n * 360.0 - 180.0;
    final latRad = math.atan(_sinh(math.pi * (1 - 2 * y / n)));
    final lat = latRad * 180.0 / math.pi;
    return LatLng(lat, lng);
  }
  
  /// Get all tile coordinates within a bounding box for a specific zoom level
  static List<math.Point<int>> getTilesInBounds(
    LatLng northWest,
    LatLng southEast,
    int zoom,
  ) {
    final nwTile = latLngToTile(northWest.latitude, northWest.longitude, zoom);
    final seTile = latLngToTile(southEast.latitude, southEast.longitude, zoom);
    
    final minX = math.min(nwTile.x, seTile.x);
    final maxX = math.max(nwTile.x, seTile.x);
    final minY = math.min(nwTile.y, seTile.y);
    final maxY = math.max(nwTile.y, seTile.y);
    
    final tiles = <math.Point<int>>[];
    for (int x = minX; x <= maxX; x++) {
      for (int y = minY; y <= maxY; y++) {
        tiles.add(math.Point(x, y));
      }
    }
    return tiles;
  }
  
  /// Calculate total number of tiles needed for bounds across multiple zoom levels
  static int calculateTileCount(
    LatLng northWest,
    LatLng southEast,
    List<int> zoomLevels,
  ) {
    int totalTiles = 0;
    for (final zoom in zoomLevels) {
      final tiles = getTilesInBounds(northWest, southEast, zoom);
      totalTiles += tiles.length;
    }
    return totalTiles;
  }
  
  /// Estimate download size in bytes for given tile count
  static int estimateDownloadSize(int tileCount, {int? avgTileSize}) {
    return tileCount * (avgTileSize ?? avgTileSizeBytes);
  }
  
  /// Get human-readable size string
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
  
  /// Get tile bounds for a circular area around a center point
  static Map<String, LatLng> getTileBounds(
    double centerLat,
    double centerLng,
    double radiusKm,
  ) {
    // Earth's radius in kilometers
    const earthRadius = 6371.0;
    
    // Convert radius to angular distance
    final angularDistance = radiusKm / earthRadius;
    
    // Calculate bounding box
    final centerLatRad = centerLat * math.pi / 180.0;
    
    // North latitude
    final northLat = math.asin(
      math.sin(centerLatRad) * math.cos(angularDistance) +
      math.cos(centerLatRad) * math.sin(angularDistance) * math.cos(0)
    ) * 180.0 / math.pi;
    
    // South latitude
    final southLat = math.asin(
      math.sin(centerLatRad) * math.cos(angularDistance) +
      math.cos(centerLatRad) * math.sin(angularDistance) * math.cos(math.pi)
    ) * 180.0 / math.pi;
    
    // East/West longitude
    final dLng = math.atan2(
      math.sin(math.pi / 2) * math.sin(angularDistance) * math.cos(centerLatRad),
      math.cos(angularDistance) - math.sin(centerLatRad) * math.sin(centerLatRad)
    ) * 180.0 / math.pi;
    
    return {
      'northWest': LatLng(northLat, centerLng - dLng),
      'southEast': LatLng(southLat, centerLng + dLng),
    };
  }
  
  /// Calculate estimated download time based on connection speed
  static Duration estimateDownloadTime(
    int totalBytes,
    double speedBytesPerSecond,
  ) {
    final seconds = (totalBytes / speedBytesPerSecond).ceil();
    return Duration(seconds: seconds);
  }
  
  /// Format duration to human-readable string
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
  
  /// Get recommended zoom levels based on usage type
  static List<int> getRecommendedZoomLevels(String quality) {
    switch (quality.toLowerCase()) {
      case 'low':
        return [10, 11, 12, 13]; // Basic area overview
      case 'medium':
        return [12, 13, 14, 15]; // Standard street-level detail
      case 'high':
        return [14, 15, 16, 17, 18]; // High detail for field-level work
      default:
        return [13, 14, 15]; // Default balanced setting
    }
  }
  
  /// Check if a tile is within valid Web Mercator bounds
  static bool isTileValid(int x, int y, int zoom) {
    final maxTile = (math.pow(2, zoom) - 1).toInt();
    return x >= 0 && x <= maxTile && y >= 0 && y <= maxTile;
  }
}
