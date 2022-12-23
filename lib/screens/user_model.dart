class UserModel {
  String? avatar;
  String? uid;
  String? userName;
  String? email;
  String? status;
  UserModel({this.avatar, this.uid, this.email, this.userName, this.status});
  factory UserModel.fromMap(map) {
    return UserModel(
      avatar: map['avatar'],
      uid: map['uid'],
      email: map['email'],
      userName: map['userName'],
      status: map['status'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'avatar': avatar,
      'uid': uid,
      'email': email,
      'userName': userName,
      'status': status,
    };
  }
}
