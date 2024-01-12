import 'package:flutter/material.dart';

class RecipesScreen extends StatefulWidget {
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  // 임의의 데이터 리스트
  final List<String> cocktail = List.generate(10, (index) => 'Cocktail ${index + 1}');
  final List<String> mycocktail = List.generate(10, (index) => 'My Cocktail ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('레시피입니다'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 검색 버튼 기능
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('칵테일입니다', style: Theme.of(context).textTheme.headline6),
            ),
            Container(
              height: 180.0, // 리스트 높이 설정
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: 160.0,
                    child: Card(
                      child: Center(
                        child: Text(cocktail[index % cocktail.length]),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('내가 만든 칵테일입니다', style: Theme.of(context).textTheme.headline6),
            ),
            Container(
              height: 180.0, // 리스트 높이 설정
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: 160.0,
                    child: Card(
                      child: Center(
                        child: Text(mycocktail[index % mycocktail.length]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
