abstract class Routes {
  static const login = '/login';
  static const home = '/';

  // Tailor nav
  static const browse = '/browse';
  static const productDetail = '/product/:id';
  static const tailorOrders = '/tailor-orders';
  static const tailorAnalytics = '/tailor-analytics';

  // Artisan nav
  static const artisanProducts = '/artisan-products';
  static const artisanOrders = '/artisan-orders';
  static const artisanAnalytics = '/artisan-analytics';
  static const addProduct = '/add-product';

  // Common
  static const profile = '/profile';
  static const settings = '/settings';
  static const payments = '/payments';
  static const help = '/help';

  // Helper
  static String productDetailPath(String id) => '/product/$id';
}