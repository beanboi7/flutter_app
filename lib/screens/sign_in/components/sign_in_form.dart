
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/helper/keyboard.dart';
import 'package:shop_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/screens/complete_profile/components/complete_profile_form.dart';
import 'package:shop_app/helper/urls.dart';
import 'package:shop_app/cache/UserCache.dart';

import 'package:http/http.dart' as http;
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'dart:convert';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String username;
  String password;
  bool remember = false;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildUserNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: Colors.lightGreen,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press : () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                KeyboardUtil.hideKeyboard(context);
                loginAuth();
                // Future res = userLogin(username, password);
                // print("Handling the press button " + "$res");
                Future checkUser = getUser();
                // print(checkUser);
                // if all are valid then go to success screen
                checkUser.then((value) => checkUser) != null  ?
                Navigator.pushNamed(context, LoginSuccessScreen.routeName) :
                Navigator.pushNamed(context, CompleteProfileScreen.routeName);

              }
            },
          ),
        ],
      ),
    );
  }

  var completeForm = new CompleteProfileForm();

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildUserNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => username= newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        } else if (userNameValidatorRegExp.hasMatch(value)) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        } else if (!userNameValidatorRegExp.hasMatch(value)) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Username",
        hintText: "Enter your username",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

//   Future<http.Response> userLogin(username, password) async{
//     // var url = 'http://192.168.0.2:8000/login';
//
//     completeForm.userName = username;
//
//     var body = json.encode(
//       {"username": username,
//       "password": password}
//     );
//
//     try {
//       var response = await http.post(
//           Urls.login,
//           headers: {"Content-Type": "application/json"},
//           body: body);
//       print("${response.statusCode}");
//       print("${response.body}");
//       return response;
//     } catch (e) {
//       print("The exception thrown is $e");
//     }
//
//
// }

  Future<http.Request> getUser() async{

    // var url = "http://192.168.0.2:8000/getUser";
    var req = await http.get(
      Urls.update,
      headers: {"Content-Type": "application/json"},
    );
    if(req.statusCode == HttpStatus.ok){
      final jsonResponse = json.decode(req.body);
      if(jsonResponse != null)
        return jsonResponse["data"];
      else{
        return jsonResponse;
      }
    }
  }

  bool loginPressed = false;
  final userCache = UserCache();

  void loginAuth() async {
    Map resp;
    bool hasError = false;
    String errMsg = "Unexpected error";
    try {
      final form = _formKey.currentState;
      if (form.validate()) {
        setState(() {
          loginPressed = true;
        });
        var dio = Dio();
        Directory appDocDir = await getApplicationDocumentsDirectory();
        var cj = PersistCookieJar(dir: appDocDir.path, ignoreExpires: false);
        dio.interceptors.add(CookieManager(cj));

        Response response = await dio.post(Urls.login, data: {
          'username': username,
          'password': password,
        });
        resp = json.decode(response.toString());
        if (resp.containsKey('success')) {
          await userCache.write(response.data);
          print("works well");
        }else {
          hasError = true;
          errMsg = "Username/password combination incorrect";
          Container(
            child: AlertDialog(
              title: Text("Invalid entry"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("Username/password combination incorrect"),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, SignInScreen.routeName);
                    },
                    child: Text("Ok")),
              ],
            ),
          );

        }
      } else {
        hasError = true;
        errMsg = "Invalid Information";
      }
    } catch (e) {
      try {
        if(e.response.data.containsKey('success') && !e.response.data['success'] && e.response.data.containsKey('msg')){
          if(e.response.data['msg'] == "Incorrect Password")
          {
            hasError = true;
            errMsg = "Incorrect Password";
          }
          else if(e.response.data['msg'] == "Incorrect Email")
          {
            hasError = true;
            errMsg = "Incorrect Email";
          }
        }
      } catch (e) {
        hasError = true;
        errMsg = "Unexpected error";
      }
    }
    if (hasError) {
      print(errMsg);
    }
  }



}



