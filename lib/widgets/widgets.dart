import 'package:chat_app_flutter/shared/constants.dart';
import 'package:flutter/material.dart';

double height(context) => MediaQuery.of(context).size.height;
double width(context) => MediaQuery.of(context).size.width;

const textInputDecoraiton = InputDecoration(
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Constants.primaryColor, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Constants.primaryColor, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Constants.primaryColor, width: 2),
  ),
);

void nextScreen(context, page) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
void nextScreenReplace(context, page) => Navigator.pushReplacement(
    context, MaterialPageRoute(builder: (context) => page));

void showSnackBar(context, color, message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          action: SnackBarAction(
            label: "OK",
            onPressed: () {},
            textColor: Colors.white,
          ),
          content: Text(message, style: const TextStyle(fontSize: 14)),
          duration: const Duration(seconds: 2),
          backgroundColor: color),
    );
