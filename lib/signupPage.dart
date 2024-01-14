import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pj3/services/authenticationService.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  final AuthenticationService _authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '이름'),
            ),
            TextFormField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            TextFormField(
              controller: _birthDateController,
              decoration: InputDecoration(labelText: '생년월일'),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                bool signUpResult = await _authService.signUpUser(
                  _nameController.text,
                  _idController.text,
                  _passwordController.text,
                  _birthDateController.text,
                );

                if (signUpResult) {
                  // 회원가입 성공 시 토스트 메시지
                  Fluttertoast.showToast(
                    msg: "회원가입 성공!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  // 로그인 화면으로 자동 이동 또는 로그인 상태 업데이트
                  Navigator.pop(context);
                } else {
                  // 회원가입 실패 시 토스트 메시지
                  Fluttertoast.showToast(
                    msg: "회원가입 실패. 다시 시도해주세요.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
