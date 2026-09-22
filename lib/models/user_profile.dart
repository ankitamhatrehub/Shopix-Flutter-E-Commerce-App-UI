class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarPath;
  final String membershipTier;
  final int points;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarPath,
    this.membershipTier = 'Gold Member',
    this.points = 450,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarPath,
    String? membershipTier,
    int? points,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarPath: avatarPath ?? this.avatarPath,
      membershipTier: membershipTier ?? this.membershipTier,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar_path': avatarPath,
      'membership_tier': membershipTier,
      'points': points,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String? ?? '',
      avatarPath: map['avatar_path'] as String?,
      membershipTier: map['membership_tier'] as String? ?? 'Gold Member',
      points: (map['points'] as int?) ?? 450,
    );
  }
}

