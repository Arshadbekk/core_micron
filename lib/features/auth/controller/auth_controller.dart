import 'package:core_micron/features/bottomNav/bottomNav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils.dart';
import '../repository/auth_repository.dart';


final authControllerProvider = NotifierProvider<AuthController,bool>(() {
  return AuthController();
});

class AuthController extends Notifier<bool>{
  AuthRepository get _authRepository => ref.read(authRepositoryProvider);



  Future loginUser({
    required BuildContext context,
    required String usernameController,
    required String passwordController,
  }) async {
    final res =
    await _authRepository.loginUser(usernameController, passwordController);

    res.fold((l) {
      print("helo");
      print(l.message);
      return showSnackBar(context, "User Not Found");
    },
            (r) async {
      showSnackBar(context, "Successfully logged in");
          // final SharedPreferences pref = await SharedPreferences.getInstance();
          // pref.setString("id", currentUser!.id.toString());
          return Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavBar(),
              ),
                  (route) => false);
        });
  }
  @override
  bool build() {
    return false;
    // TODO: implement build
    throw UnimplementedError();
  }

}