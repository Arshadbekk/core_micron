import 'package:core_micron/core/utils.dart';
import 'package:core_micron/features/auth/controller/auth_controller.dart';
import 'package:core_micron/features/bottomNav/bottomNav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool pass = false;
  void loginAdmin({required WidgetRef ref}) {
    ref.read(authControllerProvider.notifier).loginUser(
        context: context,
        usernameController: userNameController.text.trim(),
        passwordController: passwordController.text.trim());
  }

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: Container(
          height: h,
          width: w,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bg_micron.png"), fit: BoxFit.fill)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Employee Progress Card',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.06,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: h * 0.3,
                width: w * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: w,
                      height: w * 0.13,
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Please Sign In",
                          style: TextStyle(fontSize: w * 0.05),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: w * 0.13,
                      width: w * 0.8,
                      child: TextFormField(
                        controller: userNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            hintText: "User Name",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    SizedBox(
                      height: w * 0.13,
                      width: w * 0.8,
                      child: TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: pass,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  pass = !pass;
                                  setState(() {});
                                },
                                child: pass == true
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                   Consumer(builder: (context, ref, child) =>  GestureDetector(
                     onTap: () {
                       if(userNameController.text.isEmpty){
                         showSnackBar(context, "Enter username");
                       }else if(passwordController.text.isEmpty){
                         showSnackBar(context, "Enter password");
                       }else{
                         loginAdmin(ref: ref);
                       }

                     },
                     child: Container(
                       height: w * 0.15,
                       width: w * 0.8,
                       decoration: BoxDecoration(color: Colors.green),
                       child: Center(
                         child: Text(
                           "Login",
                           style: TextStyle(
                               color: Colors.white, fontSize: w * 0.05),
                         ),
                       ),
                     ),
                   ),),
                    Padding(padding: EdgeInsets.only(bottom: w * 0.01))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
