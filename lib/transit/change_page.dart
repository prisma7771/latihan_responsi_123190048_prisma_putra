import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latihan_responsi_123190048/main_menu/home_page.dart';

import '../helper/hive_database.dart';

class ChangePageHome extends StatefulWidget {
  final String user;
  final String password;
  const ChangePageHome({Key? key, required this.user, required this.password}) : super(key: key);

  @override
  State<ChangePageHome> createState() => _ChangePageHomeState();
}

class _ChangePageHomeState extends State<ChangePageHome> {
  bool isLoading = true;
  late final HiveDatabase _hive = HiveDatabase();
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
    super.initState();
    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    String? history = _hive.getHistory(widget.user);
    String? image = _hive.getImage(widget.user);
    return isLoading == true ? Container(color: Colors.white,child: const Center(child: CircularProgressIndicator())) : Homepage(username:widget.user,history: "$history", password: widget.password, image: "$image",);
  }

}