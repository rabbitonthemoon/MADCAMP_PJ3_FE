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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(_nameController, "이름"),
                SizedBox(height: 8),
                _buildTextField(_idController, "ID"),
                SizedBox(height: 8),
                _buildTextField(_passwordController, "비밀번호", isPassword: true),
                SizedBox(height: 8),
                _buildTextField(_birthDateController, "생년월일"),
                SizedBox(height: 20),
                _buildSignUpButton(),
              ],
            ),
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

  Widget _buildSignUpButton() {
    return GestureDetector(
      onTap: _attemptSignUp,
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
    );
  }
  void _attemptSignUp() async {
    String name = _nameController.text;
    String id = _idController.text;
    String password = _passwordController.text;
    String birthDate = _birthDateController.text;

    // 입력 데이터 검증
    if (name.isEmpty || id.isEmpty || password.isEmpty || birthDate.isEmpty) {
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

    // 회원가입 요청
    bool signUpResult = await _authService.signUpUser(name, id, password, birthDate);

    if (signUpResult) {
      Fluttertoast.showToast(
        msg: "회원가입 성공!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(
        msg: "회원가입 실패. 다시 시도해주세요.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}