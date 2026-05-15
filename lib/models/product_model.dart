class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String? imageUrl;
  final String sellerId;
  final String sellerName;
  final String category;
  final double rating;
  final int reviewCount;
  final int stock;
  final bool inStock;
  final String unit; // 'meter', 'yard', 'piece'

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.sellerId,
    required this.sellerName,
    required this.category,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.stock = 10,
    this.inStock = true,
    this.unit = 'meter',
  });

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'title': title,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
    'sellerId': sellerId,
    'sellerName': sellerName,
    'category': category,
    'rating': rating,
    'reviewCount': reviewCount,
    'stock': stock,
    'inStock': inStock,
    'unit': unit,
  };
}

// Demo products dataset
final List<ProductModel> demoProducts = [
  const ProductModel(
    id: 'p1',
    title: 'Premium Banarasi Silk',
    description: 'Handwoven Banarasi silk with intricate gold zari work. Perfect for bridal wear and festive occasions.',
    price: 2400,
    sellerId: 'artisan_1',
    sellerName: 'Meera Textiles',
    category: 'Silk',
    rating: 4.9,
    reviewCount: 128,
    stock: 15,
    unit: 'meter',
    imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
  ),
  const ProductModel(
    id: 'p2',
    title: 'Organic Khadi Cotton',
    description: 'Hand-spun organic khadi cotton. Breathable, lightweight, ideal for kurtas and summer wear.',
    price: 650,
    sellerId: 'artisan_2',
    sellerName: 'Village Looms',
    category: 'Cotton',
    rating: 4.7,
    reviewCount: 89,
    stock: 40,
    unit: 'meter',
    imageUrl: 'https://images.unsplash.com/photo-1616627561950-9f746e330187?w=400',
  ),
  const ProductModel(
    id: 'p3',
    title: 'Chanderi Silk Cotton',
    description: 'Traditional Chanderi fabric with subtle golden border. Lightweight and sheer with excellent drape.',
    price: 1200,
    sellerId: 'artisan_1',
    sellerName: 'Meera Textiles',
    category: 'Silk Cotton',
    rating: 4.8,
    reviewCount: 56,
    stock: 20,
    unit: 'meter',
    imageUrl: 'https://images.unsplash.com/photo-1583394293214-0b7d3ee3e0c4?w=400',
  ),
  const ProductModel(
    id: 'p4',
    title: 'Block Print Linen',
    description: 'Hand block printed linen from Bagru, Rajasthan. Natural dyes, eco-friendly.',
    price: 880,
    sellerId: 'artisan_3',
    sellerName: 'Rajasthani Crafts',
    category: 'Linen',
    rating: 4.6,
    reviewCount: 42,
    stock: 25,
    unit: 'meter',
    imageUrl: 'https://images.unsplash.com/photo-1504198453319-5ce911bafcde?w=400',
  ),
  const ProductModel(
    id: 'p5',
    title: 'Raw Tussar Silk',
    description: 'Wild-crafted Tussar silk with natural texture. Ideal for Salwar suits and sarees.',
    price: 1800,
    sellerId: 'artisan_4',
    sellerName: 'Jharkhand Silk Co.',
    category: 'Silk',
    rating: 4.7,
    reviewCount: 73,
    stock: 8,
    unit: 'meter',
    imageUrl: 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=400',
  ),
  const ProductModel(
    id: 'p6',
    title: 'Ikat Weave Dupatta',
    description: 'Double Ikat woven fabric in vibrant natural colors. From the handlooms of Odisha.',
    price: 1500,
    sellerId: 'artisan_5',
    sellerName: 'Odisha Handlooms',
    category: 'Ikat',
    rating: 4.9,
    reviewCount: 102,
    stock: 12,
    unit: 'piece',
    imageUrl: 'https://images.unsplash.com/photo-1586095431222-ea2e0a8a78ea?w=400',
  ),
];
