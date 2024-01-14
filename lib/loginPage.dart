import 'package:flutter/material.dart';
import 'package:pj3/main.dart';
import 'package:pj3/signupPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pj3/services/authenticationService.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();

  void _attemptLogin() async {
    bool result = await _authService.loginUser(
      _idController.text,
      _passwordController.text,
    );
    if (result) {
      Fluttertoast.showToast(
        msg: "로그인 성공!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainScreen()), // 메인 화면으로 이동, 클래스명 확인 필요
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("로그인 실패"),
            content: Text("등록되지 않은 아이디이거나 아이디 또는 비밀번호를 잘못 입력했습니다."),
            actions: <Widget>[
              TextButton(
                child: Text("닫기"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _attemptLogin,
              child: Text('로그인'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}