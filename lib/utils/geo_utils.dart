import '../models/fabric_listing.dart';
import 'dart:math';

/// Pure in-memory radius filtering utility.
/// Replace with geoflutterfire2 for production Firebase geo-queries.
class GeoUtils {
  static const double _earthRadius = 6371.0; // km

  static double distanceKm(double lat1, double lon1, double lat2, double lon2) {
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return _earthRadius * c;
  }

  static double _toRad(double deg) => deg * pi / 180;

  /// Filter listings within [radiusKm] of [centerLat]/[centerLon].
  /// Listings with no coordinates (0,0) are always included (local/demo data).
  static List<FabricListing> withinRadius(
    List<FabricListing> listings,
    double centerLat,
    double centerLon,
    double radiusKm,
  ) {
    return listings.where((l) {
      // Listings without real coords are treated as local
      if (l.latitude == 0 && l.longitude == 0) return true;
      return distanceKm(centerLat, centerLon, l.latitude, l.longitude) <= radiusKm;
    }).toList();
  }
}
