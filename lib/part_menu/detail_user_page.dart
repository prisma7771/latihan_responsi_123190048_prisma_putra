import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latihan_responsi_123190048/api_call/github_api_source.dart';
import 'package:latihan_responsi_123190048/helper/shared_preference.dart';
import 'package:latihan_responsi_123190048/model_user_api/github_user_model.dart';
import 'package:latihan_responsi_123190048/part_menu/part_menu_page.dart';
import 'repository_page.dart';

import '../main_menu/home_page.dart';

class DetailUserPage extends StatefulWidget {
  final String name;
  const DetailUserPage({Key? key, required this.name}) : super(key: key);

  @override
  State<DetailUserPage> createState() => _DetailUserPageState();
}

class _DetailUserPageState extends State<DetailUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Detail"),
        actions: [
          IconButton(
            onPressed: () async {
              String history = await SharedPreference.getHistory();
              String username = await SharedPreference.getUsername();
              String password = await SharedPreference.getPassword();
              String image = await SharedPreference.getImage();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => Homepage(
                          username: username,
                          password: password,
                          history: history,
                          image: image,
                        )),
                (_) => false,
              );
            },
            icon: const Icon(Icons.home),
            iconSize: 30,
          )
        ],
      ),
      body: _buildUserBody(),
    );
  }

  Widget _buildUserBody() {
    return FutureBuilder(
        future: GithubDataSource.instance.loadUsersData(widget.name),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            UserDetailModel userDetailModel =
                UserDetailModel.fromJson(snapshot.data);
            return _buildSuccessSection(userDetailModel);
          }
          return _buildLoadingSection();
        });
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorSection() {
    return const Text("Error");
  }

  Widget _buildSuccessSection(UserDetailModel data) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 400,
                child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: 1.8),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 100,
                            child: CircleAvatar(
                              radius: 95,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                "${data.avatarUrl}",
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                  child: Text("${data.login}",
                                      style: const TextStyle(fontSize: 26.0)))),
                        ),
                      ],
                    )),
              ),
            ),
            _buildItemButton(),
            // _buildListRepos(),
            // _buildListFollowers()
          ],
        ),
      ),
    );
  }

  Widget _buildItemButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          _buildItemCard("REPOSITORY", 1),
          _buildItemCard("FOLLOWING", 2),
          _buildItemCard("FOLLOWERS", 3),
        ],
      ),
    );
  }

  Widget _buildItemCard(String value, int i) {
    return Card(
      child: SizedBox(
        height: 70,
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return i == 1
                    ? RepositoryPage(name: widget.name)
                    : i == 2
                        ? PartFollowPage(name: widget.name, part: i)
                        : PartFollowPage(name: widget.name, part: i);
              }));
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontFamily: 'OpenSans'),
                ),
              ),
            )),
      ),
    );
  }
}
