import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latihan_responsi_123190048/api_call/github_api_source.dart';
import 'package:latihan_responsi_123190048/helper/shared_preference.dart';
import 'package:latihan_responsi_123190048/main_menu/home_page.dart';
import 'package:latihan_responsi_123190048/model_user_api/github_user_model.dart';
import 'detail_user_page.dart';

class PartFollowPage extends StatefulWidget {
  final String name;
  final int part;
  const PartFollowPage({Key? key, required this.name, required this.part})
      : super(key: key);

  @override
  State<PartFollowPage> createState() => _PartFollowPageState();
}

class _PartFollowPageState extends State<PartFollowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.part == 2
            ? Text("${widget.name} is Following:")
            : Text("Followers of ${widget.name}:"),
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
      body: _buildListRepos(),
    );
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorSection() {
    return const Text("Error");
  }

  Widget _buildListRepos() {
    return FutureBuilder<List<UserDetailModel>>(
        future: widget.part == 2
            ? GithubDataSource.instance.loadUsersFollowing(widget.name)
            : GithubDataSource.instance.loadUsersFollowers(widget.name),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            return _buildSuccessFollowers(snapshot);
          }
          return _buildLoadingSection();
        });
  }

  Widget _buildSuccessFollowers(AsyncSnapshot<List<UserDetailModel>> snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
                border: Border.all(width: 3, color: Colors.grey),
                borderRadius: BorderRadius.circular(25)),
            child: Center(
                child: widget.part == 2
                    ? const Text(
                        "FOLLOWING LIST",
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                      )
                    : const Text(
                        "FOLLOWERS LIST",
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                      )),
          ),
        ),
        Container(
            child: snapshot.data!.isNotEmpty
                ? Expanded(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, i) {
                              return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(25),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                            return DetailUserPage(
                                                name: "${snapshot.data![i].login}");
                                          }));
                                    },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 3, color: Colors.grey),
                                        borderRadius: BorderRadius.circular(25)),
                                    height: 100.0,
                                        child: Center(
                                          child: Text(
                                            "${snapshot.data![i].login}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'OpenSans'),
                                          ),
                                        )),
                                  ),
                              );
                            }),
                      ),
                    )
                : const Card(
                    child: SizedBox(
                      height: 100,
                      child: Center(
                          child: Text("User ini belum memiliki Followers")),
                    ),
                  )),
      ],
    );
  }
}
