import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/images/rank.png'; // 로컬 이미지 파일을 사용하는 경우

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xFF15082D), // 배경 색상 설정
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '금주의 칵테일',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFBEAFC), // 텍스트 색상 설정
              ),
            ),
            SizedBox(height: 20), // 타이틀과 이미지 사이의 간격 설정
            Container(
              decoration: BoxDecoration(
                // 그라데이션을 적용할 BoxDecoration 생성
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF15082D), Colors.transparent, Color(0xFF15082D)],
                  stops: [0.05, 0.5, 0.95],
                ),
                // BoxDecoration의 shape를 box로 설정하여 경계가 사각형이 되도록 함
                shape: BoxShape.rectangle,
              ),
              child: Image.asset(
                imagePath,
                height: MediaQuery.of(context).size.height * 0.5,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20), // 이미지와 하단 내용 사이의 간격 설정
          ],
        ),
      ),
    );
  }
}
