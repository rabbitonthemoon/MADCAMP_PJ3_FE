import 'package:flutter/material.dart';
import '/loginPage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> maincocktail = List.generate(20, (index) => 'Cocktail ${index + 1}'); //리스트 길이 임의로 넣음 일단 20

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
              // 다른 위젯을 추가 가능
            ),
          ),
          Flexible(
            flex: 1, // 하단 절반
            child: ListView.builder(
              // 가로 스크롤 설정
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 160.0, // 너비
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
              title: Text('로그인/회원가입'),
              leading: Icon(Icons.login),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            ListTile(
              title: Text('칵테일 보관함'),
              leading: Icon(Icons.collections),
              onTap: () {
                // 칵테일 보관함 페이지로 이동
              },
            ),
            // 여기에 추가적인 메뉴 아이템들을 추가할 수 있습니다.
          ],
        ),
      ),
    );
  }
}