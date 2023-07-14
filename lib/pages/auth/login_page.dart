import 'package:chat_app_flutter/helper/helper_functions.dart';
import 'package:chat_app_flutter/pages/auth/register_page.dart';
import 'package:chat_app_flutter/service/auth_service.dart';
import 'package:chat_app_flutter/service/database_service.dart';
import 'package:chat_app_flutter/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final formKey = GlobalKey<FormState>();
  String email = "", password = "";
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ))
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Fısıltı Dünyası",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic)),
                      const SizedBox(height: 10),
                      const Text("Konuşmalarını görmek için giriş yap!",
                          style: TextStyle(fontWeight: FontWeight.w400)),
                      Image.asset(
                        "assets/fd.png",
                        height: height(context) * 0.3,
                        width: width(context) * 0.3,
                      ),
                      TextFormField(
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Lütfen Geçerli Bir Email Adresi Giriniz";
                        },
                        onChanged: (value) => setState(() {
                          email = value;
                        }),
                        decoration: textInputDecoraiton.copyWith(
                          labelText: "Email",
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(height: height(context) * 0.02),
                      TextFormField(
                        obscureText: true,
                        onChanged: (value) => setState(() {
                          password = value;
                        }),
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Şifre 6 karakterden az olamaz";
                          }
                          return null;
                        },
                        decoration: textInputDecoraiton.copyWith(
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.password,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      _emptyBox,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () => login(),
                          child: const Text(
                            "Giriş",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(height: height(context) * 0.02),
                      Text.rich(
                        TextSpan(
                          text: "Hesabın yok mu? ",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black54),
                          children: [
                            TextSpan(
                              text: "Kayıt Ol",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreen(context, const RegisterPage());
                                },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await _authService
          .loginUserWithEmailandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid)
                  .gettingUserData(email);
          //saving
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmail(email);
          await HelperFunctions.saveUserName(snapshot.docs[0]['name']);
          // ignore: use_build_context_synchronously
          nextScreen(context, const HomePage());
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  Widget get _emptyBox => const SizedBox(height: 10);
}
