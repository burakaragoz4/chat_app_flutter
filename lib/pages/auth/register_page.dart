import 'package:chat_app_flutter/pages/auth/login_page.dart';
import 'package:chat_app_flutter/pages/home_page.dart';
import 'package:chat_app_flutter/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_functions.dart';
import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = "", password = "", name = "";
  bool _isLoading = false;
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ))
          : _singleChildScroll(context),
    );
  }

  SingleChildScrollView _singleChildScroll(BuildContext context) {
    return SingleChildScrollView(
      child: _padding(context),
    );
  }

  Padding _padding(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
      child: _column(context),
    );
  }

  Form _column(BuildContext context) {
    return Form(
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
          const Text(
              textAlign: TextAlign.center,
              "Sohbet etmek ve keşfetmek için şimdi hesabınızı oluşturun!",
              style: TextStyle(fontWeight: FontWeight.w400)),
          Image.asset(
            "assets/fd.png",
            height: height(context) * 0.3,
            width: width(context) * 0.3,
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Adınızı Boş Olamaz";
              }
              return null;
            },
            onChanged: (value) => setState(() {
              name = value;
            }),
            decoration: textInputDecoraiton.copyWith(
              labelText: "Name",
              prefixIcon: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          _emptyBox,
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
              onPressed: () => register(),
              child: const Text(
                "Kayıt Ol",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          SizedBox(height: height(context) * 0.02),
          Text.rich(
            TextSpan(
              text: "Zaten bir hesabınız var mı? ",
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              children: [
                TextSpan(
                  text: "Giriş Yap",
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      nextScreen(context, const LoginPage());
                    },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await _authService
          .registerUserWithEmailandPassword(name, email, password)
          .then((value) async {
        if (value == true) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserName(name);
          await HelperFunctions.saveUserEmail(email);
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
