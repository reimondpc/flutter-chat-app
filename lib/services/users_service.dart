import 'package:chat_app_test/global/environment.dart';
import 'package:chat_app_test/models/users_response.dart';
import 'package:chat_app_test/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app_test/models/user_model.dart';

class UsersService {
  Future<List<User>> getUsers() async {
    try {
      final resp = await http.get(Uri.parse('${Environment.apiUrl}/users'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      final usersResponse = usersResponseFromJson(resp.body);
      return usersResponse.users!;
    } catch (e) {
      return [];
    }
  }
}
