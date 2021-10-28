import 'package:flutter/cupertino.dart';

class AuthService {
  Future<String?> login({required String user, required String password}) async {
    debugPrint('[AuthService] login');
    // TODO: Sign in to auth
    await Future.delayed(const Duration(milliseconds: 500));
    return user;
  }

  Future<void> logout() async {
    debugPrint('[AuthService] logout');
    // TODO: logout from auth
  }
}
