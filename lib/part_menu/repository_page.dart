import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latihan_responsi_123190048/api_call/github_api_source.dart';
import 'package:latihan_responsi_123190048/helper/shared_preference.dart';
import 'package:latihan_responsi_123190048/main_menu/home_page.dart';
import 'package:latihan_responsi_123190048/model_user_api/github_user_repos_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RepositoryPage extends StatefulWidget {
  final String name;
  const RepositoryPage({Key? key, required this.name}) : super(key: key);

  @override
  State<RepositoryPage> createState() => _RepositoryPageState();
}

class _RepositoryPageState extends State<RepositoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Repository of ${widget.name}"),
        actions: [
          IconButton(
            onPressed: () async {
              String history = await SharedPreference.getHistory();
              String username = await SharedPreference.getUsername();
              String password = await SharedPreference.getPassword();
              String image = await SharedPreference.getImage();
              (image);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => Homepage(
                          history: history,
                          username: username,
                          password: password,
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
    return FutureBuilder<List<UserReposModel>>(
        future: GithubDataSource.instance.loadUsersRepo(widget.name),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            // return Card();
            return _buildSuccessRepos(snapshot);
          }
          return _buildLoadingSection();
        });
  }

  Widget _buildSuccessRepos(AsyncSnapshot<List<UserReposModel>> snapshot) {
    // return Text("${snapshot.helper![0].name}");
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
              child: const Center(
                child: Text(
                  "REPOSITORY LIST",
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold),
                ),
              )),
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
                                onTap: () async {
                                  _launchURL("https://github.com/${snapshot.data![i].fullName}");
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 3, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(25)),
                                  height: 100.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            "${snapshot.data![i].name}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'OpenSans'),
                                          ),
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
                          child: Text("User ini belum memiliki Repository")),
                    ),
                  )),
      ],
    );
  }

  void _launchURL(_url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }
}
