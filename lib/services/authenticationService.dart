import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthenticationService {
  final String _baseUrl = 'http://143.248.226.159:8080';

  Future<bool> loginUser(String userid, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'userid': userid,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // 로그인 성공
      return true;
    } else {
      // 로그인 실패
      return false;
    }
  }

  Future<bool> signUpUser(String name, String userid, String password, String birthdate) async {
    final url = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'userid' : userid,
        'password': password,
        'birthdate': birthdate, 
      }),
    );

    if (response.statusCode == 200) {
      // 회원가입 성공
      return true;
    } else {
      // 회원가입 실패
      return false;
    }
  }
}
