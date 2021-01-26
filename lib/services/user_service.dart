import 'package:shop_app/screens/sign_in/sign_in_screen.dart';



class UserService {
  String userName = '';
}

class User {
  final String username;
  final String password;

  User({this.username, this.password});

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}