import 'package:flutter/material.dart';
import 'package:pj3/main.dart';
import 'package:pj3/screens/myRecipesScreen.dart';
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
    String id = _idController.text;
    String password = _passwordController.text;

    if (id.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: "ID와 비밀번호를 모두 입력해주세요",
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    bool result = await _authService.loginUser(
      _idController.text,
      _passwordController.text,
    );
    if (result) {
      String username = await _authService.getUserById(_idController.text);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userName', username); 

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
        MaterialPageRoute(builder: (context) => HomeScreen()), 
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
      backgroundColor: Color(0xFF241D49),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(0xFFFBEAFC)),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ),
    body: Container(
      width: double.infinity,
      height: double.infinity,
      color: Color(0xFF241D49),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(_idController, "ID"),
            SizedBox(height: 8),
            _buildTextField(_passwordController, "비밀번호", isPassword: true),
            SizedBox(height: 20),
            _buildLoginButton(),
            SizedBox(height: 20),
            _buildSignUpOption(),
          ],
        ),
      ),
    ),
  );
}

Widget _buildTextField(TextEditingController controller, String hintText, {bool isPassword = false}) {
  return Container(
    width: 200,
    height: 36,
    padding: EdgeInsets.symmetric(horizontal: 16),
    alignment: Alignment.centerLeft,
    decoration: ShapeDecoration(
      color: Color(0xFF58487E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    child: TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
        border: InputBorder.none,
      ),
    ),
  );
}

    Widget _buildLoginButton() {
      return GestureDetector(
      onTap: _attemptLogin,
      child: Container(
        width: 60,
        height: 34,
        decoration: ShapeDecoration(
          color: Color(0xFF2E2456),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0x7FFBEAFC)),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          '로그인',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpOption() {
      return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SignUpPage()),
        );
      },
      child: Text(
        '회원가입',
        style: TextStyle(
        decoration: TextDecoration.underline,
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
}