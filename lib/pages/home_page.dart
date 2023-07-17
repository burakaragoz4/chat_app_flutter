import 'package:chat_app_flutter/helper/helper_functions.dart';
import 'package:chat_app_flutter/pages/auth/login_page.dart';
import 'package:chat_app_flutter/pages/profile_page.dart';
import 'package:chat_app_flutter/pages/search_page.dart';
import 'package:chat_app_flutter/service/auth_service.dart';
import 'package:chat_app_flutter/service/database_service.dart';
import 'package:chat_app_flutter/widgets/group_tile.dart';
import 'package:chat_app_flutter/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Stream? groups;
  bool _isLoading = false;
  String groupName = '';

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  //String manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  String getName(String res) {
    return res.substring(res.indexOf('_') + 1);
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

    await DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        drawer: _drawer(context),
        body: groupList(),
        floatingActionButton: _floatingActionButton);
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

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data?.data();
          if (data != null && data['groups'] != null) {
            if (data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['name']);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => popUpDiaglog(context),
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          _emptyBox,
          const Text(
            'Bir gruba katılmadınız, grup oluşturmak için ekle simgesinin üstüne tıklayın veya bir gruba katılmak için üst arama düğmesinden yardım alın.',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  get _emptyBox => const SizedBox(height: 20);
  Widget get _floatingActionButton => FloatingActionButton(
        onPressed: () {
          popUpDiaglog(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      );
  popUpDiaglog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                'Yeni Grup Oluştur',
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ))
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(20)),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        )
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text('KAPAT'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != '') {
                      setState(() {
                        _isLoading = true;
                      });

                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser?.uid)
                          .createGroup(
                              userName,
                              (FirebaseAuth.instance.currentUser?.uid)
                                  .toString(),
                              groupName)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackBar(context, Colors.green,
                          'Grup başarılıyla oluşturuldu');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text('OLUŞTUR'),
                )
              ],
            );
          }));
        });
  }
}
