import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/services/service_locator.dart';
import 'package:shop_app/services/user_service.dart';
import 'service_locator.dart';
import 'dart:math';

var storageService = locator<LocalStorageService>();
var mySavedUser = storageService.user;

class LocalStorageService {

  static LocalStorageService _instance;
  static SharedPreferences _preferences;
  String userKey = '';
  String usernameKey = '';
  // static String passwordKey = '';

  LocalStorageService(){
    this.userKey = _generateId();
    this.usernameKey = _generateId();
  }
  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  User get user {
    var userJson = getFromDisk(userKey);
    if (userJson == null) {
      return null;
    }

    return User.fromJson(json.decode(userJson));
  }

  set user(User userToSave) {
    saveStringToDisk(userKey, json.encode(userToSave.toJson()));
  }

  dynamic getFromDisk(String key) {
    var value = _preferences.get(key);
    print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  void saveStringToDisk<Type>(String key, Type content) {
    // print('(TRACE) LocalStorageService:_saveStringToDisk. key: $key value: $content');
    _saveToDisk(key, content);
  }


  //Akshat code
  var _letters =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-";

  String _getRandomString(int length, String givenString) {
    var rng = Random();
    var string = "";
    for (int i = 0; i < length; i++) {
      string += givenString[rng.nextInt(63)];
    }
    return string;
  }

  String _generateId() {
    var string1 = _getRandomString(32, _letters);
    var string2 = _getRandomString(32, _letters);
    var string3 = string1 + string2;
    var finalString = _getRandomString(32, string3);
    return finalString;
  }

  Future<String> setId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var newId = _generateId();
    await prefs.setString("key for username: ", newId);
    // HelperFunctions.currentId = newId;
    return newId;
  }

  Future<String> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("key for username: ") ?? null;
    //HelperFunctions.currentId = id;
    return id;
  }

  Future setupLocator() async {
    var instance = await LocalStorageService.getInstance();
    locator.registerSingleton<LocalStorageService>(instance);
  }

  String get username => getFromDisk(usernameKey) ?? "Not found";
  set username(String username) => _saveToDisk(_generateId(), username);

  void _saveToDisk<T>(String key, T content) {
    print('(TRACE) LocalStorageService:_saveToDisk. key: $key value: $content');

    if (content is String) {
      _preferences.setString(key, content);
    }
    if (content is bool) {
      _preferences.setBool(key, content);
    }
    if (content is int) {
      _preferences.setInt(key, content);
    }
    if (content is double) {
      _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }
}
