class SustainabilityImpact {
  final int totalListings;
  final double estimatedWasteSavedKg;
  final int totalOrders;
  final int activeUsers;
  final int swapsCompleted;

  SustainabilityImpact({
    this.totalListings = 0,
    this.estimatedWasteSavedKg = 0,
    this.totalOrders = 0,
    this.activeUsers = 0,
    this.swapsCompleted = 0,
  });

  double get communityScore {
    if (activeUsers == 0) return 0;
    return (swapsCompleted / activeUsers) * 100;
  }

  SustainabilityImpact copyWith({
    int? totalListings,
    double? estimatedWasteSavedKg,
    int? totalOrders,
    int? activeUsers,
    int? swapsCompleted,
  }) =>
      SustainabilityImpact(
        totalListings: totalListings ?? this.totalListings,
        estimatedWasteSavedKg:
            estimatedWasteSavedKg ?? this.estimatedWasteSavedKg,
        totalOrders: totalOrders ?? this.totalOrders,
        activeUsers: activeUsers ?? this.activeUsers,
        swapsCompleted: swapsCompleted ?? this.swapsCompleted,
      );
}
