import 'package:flutter/foundation.dart';
import '../models/user.dart';

/// Local auth service that mirrors Firebase Auth API.
/// Swap out with real FirebaseAuth when credentials are ready.
class AuthService extends ChangeNotifier {
  AppUser? _currentUser;
  bool _isLoading = false;
  String? _error;

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  bool get isTailor => _currentUser?.role == UserRole.tailor;
  bool get isArtisan => _currentUser?.role == UserRole.artisan;
  String? get error => _error;

  // ─────────────── SIGN UP ───────────────
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required UserRole role,
  }) async {
    _setLoading(true);

    // Validation
    if (name.trim().isEmpty) throw Exception('Please enter your full name.');
    if (!email.contains('@') || !email.contains('.')) throw Exception('Please enter a valid email address.');
    if (password.length < 6) throw Exception('Password must be at least 6 characters.');
    if (password != confirmPassword) throw Exception('Passwords do not match.');

    // Check if already registered (in-memory mock)
    if (_registeredUsers.containsKey(email.toLowerCase())) {
      _setLoading(false);
      throw Exception('An account with this email already exists. Please login instead.');
    }

    await Future.delayed(const Duration(milliseconds: 800));

    final uid = 'uid_${DateTime.now().millisecondsSinceEpoch}';
    final user = AppUser(
      id: uid,
      name: name.trim(),
      email: email.trim().toLowerCase(),
      role: role,
      isVerified: true,
    );

    // Store in local registry (simulates Firestore users collection)
    _registeredUsers[email.toLowerCase()] = _StoredUser(
      user: user,
      password: password,
    );

    _currentUser = user;
    _setLoading(false);
  }

  // ─────────────── SIGN IN ───────────────
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    if (email.trim().isEmpty) {
      _setLoading(false);
      throw Exception('Please enter your email address.');
    }
    if (password.isEmpty) {
      _setLoading(false);
      throw Exception('Please enter your password.');
    }

    await Future.delayed(const Duration(milliseconds: 700));

    final stored = _registeredUsers[email.trim().toLowerCase()];

    if (stored == null) {
      _setLoading(false);
      throw Exception('No account found with this email. Please sign up first.');
    }

    if (stored.password != password) {
      _setLoading(false);
      throw Exception('Wrong password. Please try again.');
    }

    _currentUser = stored.user;
    _setLoading(false);
  }

  // ─────────────── SIGN OUT ───────────────
  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }

  // ─────────────── HELPERS ───────────────
  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  // In-memory user store (mimics Firestore)
  final Map<String, _StoredUser> _registeredUsers = {
    // Pre-seeded demo accounts
    'tailor@demo.com': _StoredUser(
      user: AppUser(
        id: 'demo_tailor_001',
        name: 'Ramesh Kumar',
        email: 'tailor@demo.com',
        role: UserRole.tailor,
        isVerified: true,
      ),
      password: 'demo1234',
    ),
    'artisan@demo.com': _StoredUser(
      user: AppUser(
        id: 'demo_artisan_001',
        name: 'Meera Devi',
        email: 'artisan@demo.com',
        role: UserRole.artisan,
        isVerified: true,
        shopName: 'Meera Textiles',
      ),
      password: 'demo1234',
    ),
  };
}

class _StoredUser {
  final AppUser user;
  final String password;
  _StoredUser({required this.user, required this.password});
}
