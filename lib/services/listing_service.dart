import 'package:flutter/foundation.dart';
import '../models/fabric_listing.dart';

class ListingService extends ChangeNotifier {
  final List<FabricListing> _listings = [];
  bool _isLoading = false;

  List<FabricListing> get listings => List.unmodifiable(_listings);
  bool get isLoading => _isLoading;

  ListingService() {
    _loadSampleListings();
  }

  void _loadSampleListings() {
    _listings.addAll([
      FabricListing(
        id: '1',
        sellerId: 's1',
        sellerName: 'Artisan Rahul',
        title: 'Organic Handwoven Cotton',
        description: 'Pure organic cotton with natural dyes.',
        materialType: FabricMaterialType.organic,
        color: 'Indigo',
        quantity: 10.0,
        price: 450,
        swapAllowed: true,
        locationName: 'Ahmedabad',
        imageUrls: [],
        rating: 4.8,
        reviewCount: 12,
      ),
      FabricListing(
        id: '2',
        sellerId: 's2',
        sellerName: 'Silk Heritage',
        title: 'Premium Silk Blend',
        description: 'Luxurious silk blend for bridal wear.',
        materialType: FabricMaterialType.silk,
        color: 'Crimson',
        quantity: 5.0,
        price: 1200,
        swapAllowed: false,
        locationName: 'Varanasi',
        imageUrls: [],
        rating: 4.9,
        reviewCount: 45,
      ),
      FabricListing(
        id: '3',
        sellerId: 's3',
        sellerName: 'Linen Works',
        title: 'Rustic Handwoven Linen',
        description: 'Sturdy linen with a premium texture.',
        materialType: FabricMaterialType.linen,
        color: 'Beige',
        quantity: 15.0,
        price: 850,
        swapAllowed: true,
        locationName: 'Jaipur',
        imageUrls: [],
        rating: 4.7,
        reviewCount: 28,
      ),
      FabricListing(
        id: '4',
        sellerId: 's4',
        sellerName: 'Modern Textiles',
        title: 'Soft Denim Scraps',
        description: 'High-quality denim offcuts from garment factory.',
        materialType: FabricMaterialType.denim,
        color: 'Light Blue',
        quantity: 2.5,
        price: 150,
        swapAllowed: true,
        locationName: 'Surat',
        imageUrls: [],
        rating: 4.5,
        reviewCount: 8,
      ),
    ]);
  }

  List<FabricListing> getActive() => _listings.where((l) => l.status == ListingStatus.active).toList();

  List<FabricListing> search(String query) {
    final q = query.toLowerCase();
    return _listings.where((l) {
      return l.title.toLowerCase().contains(q) ||
          l.materialType.name.toLowerCase().contains(q) ||
          l.locationName.toLowerCase().contains(q);
    }).toList();
  }
}
