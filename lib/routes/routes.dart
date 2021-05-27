import 'package:chat_app_test/pages/chat_page.dart';
import 'package:chat_app_test/pages/loading_page.dart';
import 'package:chat_app_test/pages/login_page.dart';
import 'package:chat_app_test/pages/register_page.dart';
import 'package:chat_app_test/pages/user_page.dart';

final routes = {
  'user': (_) => UserPage(),
  'chat': (_) => ChatPage(),
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'loading': (_) => LoadingPage(),
};
