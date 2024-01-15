import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthenticationService {
  final String _baseUrl = 'http://143.248.226.40:8080';

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

  Future<String> getUserName() async {
    
    // 사용자 이름 가져오는 API
    final url = Uri.parse('$_baseUrl/user/userid');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['name'];
    } else {
      throw Exception('실패');
    }
  }

  Future<List<Cocktail>> fetchCocktails() async {
    final url = Uri.parse('$_baseUrl/cock/get-all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // List<dynamic> cocktailsJson = json.decode(response.body);
      List<dynamic> cocktailsJson = json.decode(utf8.decode(response.bodyBytes));
      return cocktailsJson.map((json) => Cocktail.fromJson(json)).toList();
    } else {
      throw Exception('실패');
    }
  }
}

class Cocktail {
  final String name;
  final String explanation;
  final String ingredients;
  final String recipe;
  final int recommend;
  final String cockimg;

  Cocktail({
    required this.name,
    required this.explanation,
    required this.ingredients,
    required this.recipe,
    required this.recommend,
    required this.cockimg,
  });

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    return Cocktail(
      name: json['name'],
      explanation: json['explanation'],
      ingredients: json['ingredients'],
      recipe: json['recipe'],
      recommend: json['recommend'] ?? 0,
      cockimg: json['cockimg'],
    );
  }
}
