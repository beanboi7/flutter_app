
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class UserCache{
  Future _initialization;
  SharedPreferences RAM;

  UserCache() {
    _initialization = initializeObject();
  }

  Future initializeObject() async {
    RAM = await SharedPreferences.getInstance();
  }

  Future get ensureInitialization => _initialization;

  Future<void> write(var response) async {
    try {
      await this.ensureInitialization;
      await RAM.setString("UserCache", json.encode(response));
    } catch (e) {
      print("[ERROR] " + e.toString());
    }
  }

  Future<String> read() async {
    try {
      await this.ensureInitialization;
      String contents = RAM.getString("UserCache");
      if (contents == null || contents == "")
        return "{}";
      else
        return contents;
    } catch (e) {
      print("[ERROR] " + e.toString());
      return "{}";
    }
  }

  Future<bool> exists() async {
    try {
      await this.ensureInitialization;
      String contents = RAM.getString("UserCache");
      if (contents == null || contents == "")
        return false;
      else
        return true;
    } catch (e) {
      print("[ERROR] " + e.toString());
      return false;
    }
  }

  Future<void> delete() async {
    try {
      await this.ensureInitialization;
      await RAM.remove("UserCache");
    } catch (e) {
      print("[ERROR] " + e.toString());
    }
  }
}