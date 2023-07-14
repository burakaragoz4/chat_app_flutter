import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppbarPage extends StatefulWidget {
  String text;
  AppbarPage({super.key, required this.text});

  @override
  State<AppbarPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AppbarPage> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(widget.text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold)));
  }
}
