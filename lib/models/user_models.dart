class Profile {
  final String id;
  final String fullName;
  final String? phone;
  final String role;
  final String preferredLanguage;
  final String? avatarUrl;

  Profile({
    required this.id,
    required this.fullName,
    this.phone,
    required this.role,
    required this.preferredLanguage,
    this.avatarUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullName: json['full_name'],
      phone: json['phone'],
      role: json['role'],
      preferredLanguage: json['preferred_language'],
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'role': role,
      'preferred_language': preferredLanguage,
      'avatar_url': avatarUrl,
    };
  }
}

class Farmer {
  final String id;
  final String profileId;
  final String? districtId;
  final String village;
  final double? totalLandBigha;

  Farmer({
    required this.id,
    required this.profileId,
    this.districtId,
    required this.village,
    this.totalLandBigha,
  });

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      id: json['id'],
      profileId: json['profile_id'],
      districtId: json['district_id'],
      village: json['village'],
      totalLandBigha: json['total_land_bigha']?.toDouble(),
    );
  }
}
