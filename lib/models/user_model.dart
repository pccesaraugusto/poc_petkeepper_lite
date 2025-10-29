class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final bool profileCompleted;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.profileCompleted = false,
  });

  // Criar uma instância a partir de um Map (exemplo Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      id: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      profileCompleted: map['profileCompleted'] ?? false,
    );
  }

  // Converter para Map para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'profileCompleted': profileCompleted,
    };
  }
}
