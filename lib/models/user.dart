enum UserRole { tailor, artisan }

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final bool isVerified;
  final String? photoUrl;
  final String? shopName;
  final String? phone;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isVerified = true,
    this.photoUrl,
    this.shopName,
    this.phone,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  AppUser copyWith({
    String? name,
    String? photoUrl,
    String? shopName,
    String? phone,
    bool? isVerified,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email,
      role: role,
      isVerified: isVerified ?? this.isVerified,
      photoUrl: photoUrl ?? this.photoUrl,
      shopName: shopName ?? this.shopName,
      phone: phone ?? this.phone,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'uid': id,
    'name': name,
    'email': email,
    'role': role.name,
    'isVerified': isVerified,
    'shopName': shopName,
    'phone': phone,
    'createdAt': createdAt.toIso8601String(),
  };

  static AppUser fromFirestore(Map<String, dynamic> data, String uid) => AppUser(
    id: uid,
    name: data['name'] ?? '',
    email: data['email'] ?? '',
    role: data['role'] == 'artisan' ? UserRole.artisan : UserRole.tailor,
    isVerified: data['isVerified'] ?? true,
    shopName: data['shopName'],
    phone: data['phone'],
    createdAt: data['createdAt'] != null
        ? DateTime.tryParse(data['createdAt']) ?? DateTime.now()
        : DateTime.now(),
  );
}
