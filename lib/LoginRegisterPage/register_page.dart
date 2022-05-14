import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latihan_responsi_123190048/helper/hive_database.dart';
import 'package:latihan_responsi_123190048/hive_model/account_model.dart';

import '../common_submit_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool isExist = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final HiveDatabase _hive = HiveDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Page"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height-80,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Center(child: Text("REGISTRATION FORM", style: TextStyle(fontSize: 34, fontFamily: 'OpenSans'),),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.white70),
                  labelText: "USERNAME",
                  hintText: "USERNAME",
                  hintStyle: TextStyle(color: Colors.white38),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.grey),
                      borderRadius:
                      BorderRadius.all(Radius.circular(25.0))
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.grey),
                      borderRadius:
                      BorderRadius.all(Radius.circular(25.0))
                  ),

                ),
                validator: (value) => value!.isEmpty ? 'Username cannot be blank':null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.white70),
                  label: Text("PASSWORD"),
                  hintText: "PASSWORD",
                  hintStyle: TextStyle(color: Colors.white38),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.grey),
                      borderRadius:
                      BorderRadius.all(Radius.circular(25.0))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.grey),
                      borderRadius:
                      BorderRadius.all(Radius.circular(25.0))
                  ),
                ),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Password cannot be blank' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: _buildRegisterButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return CommonSubmitButton(
      labelButton: "REGISTER",
      submitCallback: (value) {
        isExist = _hive.checkUsers(_usernameController.text);
        if (isExist == false && _usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
          _hive.addData(
              UserAccountModel(
                  username: _usernameController.text,
                  password: _passwordController.text,
                  history: '',
                  image: ''
              )
          );
          _usernameController.clear();
          _passwordController.clear();
          setState(() {});

          Navigator.pop(context);
        }
        else{
          _showToast("Akun Sudah Ada",
              duration: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        }
      },
    );
  }

  void _showToast(String msg, {Toast? duration, ToastGravity? gravity}){
    Fluttertoast.showToast(msg: msg, toastLength: duration, gravity: gravity);
  }
}
