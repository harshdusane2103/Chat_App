class UserModel {
  String? name, email, image, phone, token;
  bool isOnline,isTyping;

  UserModel(
      {required this.name,
      required this.email,
      required this.image,
      required this.phone,
      required this.token,
      required this.isOnline,
        required this.isTyping
      });

  factory UserModel.fromMap(Map m1) {
    return UserModel(
      name: m1['name'],
      email: m1['email'],
      image: m1['image'],
      phone: m1['phone'],
      token: m1['token'],
      isOnline: m1['isOnline']??false,
      isTyping: m1['isTyping']??false,
    );
  }

  Map<String, dynamic> toMap(UserModel user) {
    return {
      'name': user.name,
      'email': user.email,
      'image': user.image,
      'phone': user.phone,
      'token': user.token,
      'isOnline':user.isOnline,
      'isTyping':user.isTyping,

    };
  }
}
