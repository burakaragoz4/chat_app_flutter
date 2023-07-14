import 'package:chat_app_flutter/pages/home_page.dart';
import 'package:chat_app_flutter/service/auth_service.dart';
import 'package:chat_app_flutter/widgets/appbar_page.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';
import 'auth/login_page.dart';

// ignore: must_be_immutable
class ProfilerPage extends StatefulWidget {
  String userName, userEmail;
  ProfilerPage({super.key, required this.userName, required this.userEmail});

  @override
  State<ProfilerPage> createState() => _ProfilerPageState();
}

class _ProfilerPageState extends State<ProfilerPage> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppbarPage(text: 'Profil')),
      drawer: _drawer(context),
      body: const Center(
        child: Text('Profil Sayfası'),
      ),
    );
  }

  Drawer _drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: [
          Icon(
            Icons.account_circle,
            size: 150,
            color: Colors.grey[700],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            widget.userName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          const Divider(height: 2),
          ListTile(
            onTap: () {
              nextScreen(context, const HomePage());
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text('Gruplar', style: TextStyle(color: Colors.black)),
          ),
          ListTile(
            onTap: () {},
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text('Profil', style: TextStyle(color: Colors.black)),
          ),
          ListTile(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Çıkış Yap'),
                      content:
                          const Text('Çıkış yapmak istediğinize emin misiniz?'),
                      actions: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.cancel, color: Colors.red),
                        ),
                        IconButton(
                            onPressed: () async {
                              await _authService.signOut();
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
                            },
                            icon: const Icon(Icons.done, color: Colors.green))
                      ],
                    );
                  });
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.exit_to_app),
            title:
                const Text('Çıkış Yap', style: TextStyle(color: Colors.black)),
          )
        ],
      ),
    );
  }
}
