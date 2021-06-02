import 'package:chat_app_test/global/environment.dart';
import 'package:chat_app_test/models/messages_response.dart';
import 'package:chat_app_test/models/user_model.dart';
import 'package:chat_app_test/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  User? userPara;

  Future<List<Message>> getMessages(String userID) async {
    final resp = await http.get(
      Uri.parse('${Environment.apiUrl}/messages/$userID'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken(),
      },
    );

    final messagesResp = messagesResponseFromJson(resp.body);

    return messagesResp.messages!;
  }
}
