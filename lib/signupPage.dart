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
        backgroundColor: Color(0xFF241D49),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFFFBEAFC),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF241D49),
        child: Stack(
          children: [
            // 이름!!!!
            Positioned(
              left: 80,
              top: 202,
                child: Container(
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
                    controller: _nameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: '이름',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              // ID!!!!
              Positioned(
                left: 80,
                top: 250,
                child: Container(
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
                    controller: _idController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'ID',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize:12),
                      border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              // 비밀번호!!!!
              Positioned(
                left: 80,
                top: 298,
                child: Container(
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
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: '비밀번호',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            // 생년월일!!!!
            Positioned(
              left: 80,
              top: 346,
              child: Container(
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
                  controller: _birthDateController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '생년월일',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            // 회원가입!!!!
            Positioned(
              left: 144,
              top: 394,
              child: GestureDetector(
                onTap: () async {
                  String name = _nameController.text;
                  String id = _idController.text;
                  String password = _passwordController.text;
                  String birthdate = _birthDateController.text;

                  if (name.isEmpty || id.isEmpty || password.isEmpty || birthdate.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "모든 필드를 입력해주세요",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }

                  bool signUpResult = await _authService.signUpUser(
                    _nameController.text,
                    _idController.text,
                    _passwordController.text,
                    _birthDateController.text,
                  );
                  if (signUpResult) {
                    Fluttertoast.showToast(
                      msg: "회원가입 성공!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(
                      msg: "회원가입 실패. 다시시도해주세요.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
                child: Container(
                  width: 72,
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
                    '회원가입',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}