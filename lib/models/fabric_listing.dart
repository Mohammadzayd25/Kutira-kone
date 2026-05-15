enum FabricMaterialType {
  cotton,
  silk,
  denim,
  linen,
  velvet,
  wool,
  polyester,
  handmade,
  organic,
}

enum ListingStatus {
  active,
  sold,
  archived,
}

class FabricListing {
  final String id;
  final String sellerId;
  final String sellerName;
  final String title;
  final String description;
  final FabricMaterialType materialType;
  final String color;
  final double quantity; // in meters
  final String quantityUnit;
  final double price;
  final bool swapAllowed;
  final List<String> imageUrls;
  final double latitude;
  final double longitude;
  final String locationName;
  final ListingStatus status;
  final DateTime createdAt;
  final double rating;
  final int reviewCount;

  FabricListing({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.title,
    required this.description,
    required this.materialType,
    required this.color,
    required this.quantity,
    this.quantityUnit = 'meters',
    required this.price,
    required this.swapAllowed,
    required this.imageUrls,
    this.latitude = 0.0,
    this.longitude = 0.0,
    required this.locationName,
    this.status = ListingStatus.active,
    DateTime? createdAt,
    this.rating = 4.5,
    this.reviewCount = 0,
  }) : createdAt = createdAt ?? DateTime.now();
}
