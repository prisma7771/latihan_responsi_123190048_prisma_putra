import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latihan_responsi_123190048/hive_model/account_model.dart';
import 'transit/change_page.dart';
import 'transit/change_page_login.dart';
import 'helper/shared_preference.dart';

void main() async {
  initiateLocalDB();
  WidgetsFlutterBinding.ensureInitialized();
  String username = await SharedPreference.getUsername();
  String password = await SharedPreference.getPassword();
  bool status = await SharedPreference.getLoginStatus();
  runApp(MaterialApp(
      home: status == true
          ? MyApp(
              username: username,
              password: password,
            )
          : const ChangePageLogin(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade800,
        ),
        primaryColor: Colors.green.shade800,
      )));
}

void initiateLocalDB() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAccountModelAdapter());
  await Hive.openBox<UserAccountModel>("account");
}

class MyApp extends StatefulWidget {
  final String username;
  final String password;
  const MyApp({Key? key, required this.username, required this.password})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;

  void startTimer() {
    Timer.periodic(const Duration(seconds: 2), (t) {
      setState(() {
        isLoading = false; //set loading to false
      });
      t.cancel(); //stops the timer
    });
  }

  @override
  void initState() {
    //start the timer on loading
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()))
        : ChangePageHome(
            user: widget.username,
            password: widget.password,
          );
  }
}
