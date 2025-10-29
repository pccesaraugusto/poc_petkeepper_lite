class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String familyCode;
  final List<String> fcmTokens;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.familyCode,
    required this.fcmTokens,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      id: documentId,
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      familyCode: map['familyCode'] ?? '',
      fcmTokens: List<String>.from(map['fcmTokens'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'familyCode': familyCode,
      'fcmTokens': fcmTokens,
    };
  }
}
