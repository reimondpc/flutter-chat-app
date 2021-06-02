import 'package:chat_app_test/models/user_model.dart';
import 'package:chat_app_test/services/auth_service.dart';
import 'package:chat_app_test/services/chat_service.dart';
import 'package:chat_app_test/services/socket_service.dart';
import 'package:chat_app_test/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final usersService = UsersService();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<User> users = [];

  @override
  void initState() {
    _cargarUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context).user!;
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(authService.name!, style: TextStyle(color: Colors.black87)),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.black87),
            onPressed: () {
              socketService.disconnect();
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            }),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon(Icons.check_circle, color: Colors.blue[400])
                : Icon(Icons.offline_bolt, color: Colors.red),
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
    users = await usersService.getUsers();
    setState(() {});

    _refreshController.refreshCompleted();
  }
}

class _UserTile extends StatelessWidget {
  final User user;

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
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userPara = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }
}
