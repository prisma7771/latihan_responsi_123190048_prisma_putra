import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latihan_responsi_123190048/main_menu/image_picker/image_picker_section.dart';
import 'package:latihan_responsi_123190048/part_menu/detail_user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_call/github_api_source.dart';
import '../transit/change_page_login.dart';
import '../helper/hive_database.dart';
import '../helper/shared_preference.dart';

class Homepage extends StatefulWidget {
  final String username;
  final String password;
  final String history;
  final String image;
  const Homepage(
      {Key? key,
      required this.history,
      required this.username,
      required this.password, required this.image})
      : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  late final HiveDatabase _hive = HiveDatabase();
  List<String> history = [];
  @override
  initState() {
    super.initState();
    setState(() {
      widget.history.isEmpty ? history = [] : history.add(widget.history);
    }); // Add listeners to this class
  }
  List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(history);
    return matches;
  }

  void _showToast(String msg, {Toast? duration, ToastGravity? gravity}) {
    Fluttertoast.showToast(msg: msg, toastLength: duration, gravity: gravity);
  }

  @override
  Widget build(BuildContext context) {
    (widget.history);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("HOMEPAGE"), actions: [
        Center(child: Text("Hello, ${widget.username}", style: TextStyle(fontSize: 18),)),
        IconButton(
          onPressed: () {
            SharedPreference().setLogout();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ChangePageLogin()),
              (_) => false,
            );
          },
          icon: const Icon(Icons.logout),
        )
      ]),
      body: SingleChildScrollView(child: _buildPage()),
    );
  }

  Widget _buildPage() {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 80,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 3, color: Colors.white54),
                  borderRadius: BorderRadius.circular(45),
              color: Colors.black12),
              height: MediaQuery.of(context).size.height - 400,
              child: SingleChildScrollView(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ImagePickerSection(username: widget.username, image: widget.image, history: widget.history, password: widget.password,),
              )),
            ),
            _searchBar(),
            _history(),
          ]),
        ));
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        children: [
          SizedBox(
            height: 70,
            width: MediaQuery.of(context).size.width - 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TypeAheadField(
                hideOnEmpty: true,
                suggestionsCallback: (pattern) {
                  return getSuggestions(pattern);
                },
                textFieldConfiguration: TextFieldConfiguration(
                    controller: _searchController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.white70),
                        labelText: "FIND GITHUB USER",
                        hintText: "Search Github User",
                        prefixIcon: Icon(Icons.search, color: Colors.white,),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: Colors.grey),
                            borderRadius:
                            BorderRadius.all(Radius.circular(25.0))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: Colors.grey),
                            borderRadius:
                            BorderRadius.all(Radius.circular(25.0))))),
                onSuggestionSelected: (String suggestion) {
                  _searchController.text = suggestion;
                },
                itemBuilder: (context, String suggestion) {
                  return ListTile(
                    title: Text("Last Search: " + suggestion),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                // padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    String _search = _searchController.value.text;
                    var data =
                        (await GithubDataSource.instance.loadUsersData(_search));
                    if (data['message'] == "Not Found") {
                      _showToast("User Tidak Ada",
                          duration: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM);
                    } else if (data['login'].toLowerCase() ==
                        _search.toLowerCase()) {
                      if (history.isEmpty) {
                        setState(() {
                          history.add(_search);
                        });
                      } else {
                        setState(() {
                          history[0] = _search;
                        });
                      }
                      SharedPreference().setHistory(_search);
                      String imagePref = await SharedPreference.getImage();
                      _hive.updateHistory(
                          widget.username, widget.password, _search, imagePref);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return DetailUserPage(
                          name: _search,
                        );
                      }));
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  child: const Icon(Icons.search),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _history() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 3, color: Colors.white54),
          borderRadius: BorderRadius.circular(45)),
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Center(child: Text("Last Search:", style: TextStyle(fontSize: 24),)),
          history.isEmpty
              ? const Text("Tidak Ada Riwayat Pencarian", style: TextStyle(fontSize: 16),)
              : InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return DetailUserPage(
                        name: history[0],
                      );
                    }));
                  },
                  child: Text(
                    history[0],
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  )),
        ],
      ),
    );
  }
}
