class Users {
  late String path;
  late String name;
  late String email;
  late String password;
  late String mobile;
  late String levelUser;
  late bool isSuspend ;
  late String fcm;

  Users();

  Users.data(
      {required this.path,
      required this.name,
      required this.email,
      required this.password,
      required this.mobile,
      required this.fcm,
      required this.levelUser,
      required this.isSuspend});

  Users.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    email = map['email'];
    password = map['password'];
    mobile = map['mobile'];
    levelUser = map['levelUser'];
    isSuspend = map['isSuspend'];
    fcm = map['fcm'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['name'] = name;
    map['email'] = email;
    map['password'] = password;
    map['mobile'] = mobile;
    map['levelUser'] = levelUser;
    map['isSuspend'] = isSuspend;
    map['fcm'] = fcm;
    return map;
  }
}
