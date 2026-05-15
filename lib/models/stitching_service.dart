enum StitchingCategory {
  mens,
  womens,
  kids,
  bridal,
  custom,
  alteration,
}

class StitchingServiceItem {
  final String id;
  final String tailorId;
  final String title;
  final String description;
  final StitchingCategory category;
  final double basePrice;
  final List<String> imageUrls;
  final int turnaroundDays;

  StitchingServiceItem({
    required this.id,
    required this.tailorId,
    required this.title,
    required this.description,
    required this.category,
    required this.basePrice,
    required this.imageUrls,
    required this.turnaroundDays,
  });
}
