import 'package:chat_app_test/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final users = [
    User(uid: '1', name: 'Ani', email: 'test1@test.com', online: true),
    User(uid: '2', name: 'Russell', email: 'test2@test.com', online: false),
    User(uid: '3', name: 'Kevin', email: 'test3@test.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Nombre', style: TextStyle(color: Colors.black87)),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.black87),
            onPressed: () {}),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            // child: Icon(Icons.check_circle, color: Colors.blue[400]),
            child: Icon(Icons.offline_bolt, color: Colors.red),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUser,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Color(0xFF42A5F5),
        ),
        child: _listViewUser(),
      ),
    );
  }

  ListView _listViewUser() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      separatorBuilder: (_, i) => Divider(),
      itemCount: users.length,
      itemBuilder: (_, i) => _UserTile(users[i]),
    );
  }

  _cargarUser() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}

class _UserTile extends StatelessWidget {
  User user;

  _UserTile(this.user);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name!),
      subtitle: Text(user.email!),
      leading: CircleAvatar(child: Text(user.name!.substring(0, 2))),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: user.online! ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
