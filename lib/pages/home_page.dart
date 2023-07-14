import 'package:chat_app_flutter/helper/helper_functions.dart';
import 'package:chat_app_flutter/pages/auth/login_page.dart';
import 'package:chat_app_flutter/pages/profile_page.dart';
import 'package:chat_app_flutter/pages/search_page.dart';
import 'package:chat_app_flutter/service/auth_service.dart';
import 'package:chat_app_flutter/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: unused_field
  final AuthService _authService = AuthService();
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFrom().then((value) {
      setState(() {
        userEmail = value!;
      });
    });
    await HelperFunctions.getUserNameFrom().then((value) {
      setState(() {
        userName = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      drawer: _drawer(context),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
            onPressed: () => nextScreen(context, const SearchPage()),
            icon: const Icon(Icons.search))
      ],
      elevation: 0,
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text(
        'Gruplar',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
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
            userName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          const Divider(height: 2),
          ListTile(
            onTap: () {},
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text('Gruplar', style: TextStyle(color: Colors.black)),
          ),
          ListTile(
            onTap: () {
              nextScreenReplace(context,
                  ProfilerPage(userName: userName, userEmail: userEmail));
            },
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
