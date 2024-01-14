import 'package:flutter/material.dart';
import '/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> maincocktail = List.generate(20, (index) => 'Cocktail ${index + 1}');
  String _username = "게스트";
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _username = prefs.getString('userName') ?? "게스트";
    });
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userName');

    setState(() {
      _isLoggedIn = false;
      _username = "게스트";
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이것이 앱 이름입니다'),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1, // 상단 절반
            child: Container(
              // 다른 위젯
            ),
          ),
          Flexible(
            flex: 1, // 하단 절반
            child: ListView.builder(
              // 가로 스크롤 설정
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 160.0,
                  child: Card(
                    child: Center(
                      // child: Text('Drink $index'),
                      child: Text(maincocktail[index % maincocktail.length]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer( // 오른쪽에서 나오는 드로어
        child: ListView(
          children: [
            ListTile(
              // title: Text('로그인/회원가입'),
              // leading: Icon(Icons.login),
              title: Text(_isLoggedIn ? '$_username 님' : '로그인/회원가입'),
              leading: Icon(_isLoggedIn ? Icons.person : Icons.login),
              onTap: () {
                if (!_isLoggedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                } else {
                  _logout();
                }
              },
            ),
            ListTile(
              title: Text('칵테일 보관함'),
              leading: Icon(Icons.collections),
              onTap: () {
                // 칵테일 보관함 페이지로 이동
              },
            ),
          ],
        ),
      ),
    );
  }
}