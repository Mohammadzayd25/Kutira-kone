import 'package:flutter/foundation.dart';
import '../models/sustainability.dart';

class SustainabilityService extends ChangeNotifier {
  SustainabilityImpact _impact = SustainabilityImpact();

  SustainabilityImpact get impact => _impact;

  void recordListing(double estimatedKg) {
    _impact = _impact.copyWith(
      totalListings: _impact.totalListings + 1,
      estimatedWasteSavedKg: _impact.estimatedWasteSavedKg + estimatedKg,
    );
    notifyListeners();
  }

  void recordOrder({required bool isSwap}) {
    _impact = _impact.copyWith(
      totalOrders: _impact.totalOrders + 1,
      swapsCompleted: isSwap ? _impact.swapsCompleted + 1 : _impact.swapsCompleted,
    );
    notifyListeners();
  }

  void setActiveUsers(int count) {
    _impact = _impact.copyWith(activeUsers: count);
    notifyListeners();
  }
}
