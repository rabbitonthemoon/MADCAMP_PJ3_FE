import 'package:flutter/material.dart';

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
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // 메뉴 버튼
            },
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
    );
  }
}