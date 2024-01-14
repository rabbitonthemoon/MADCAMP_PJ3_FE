import 'package:flutter/material.dart';
import 'package:pj3/services/authenticationService.dart';

class RecipesScreen extends StatefulWidget {
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  // 임의의 데이터 리스트
  // final List<String> cocktail = List.generate(10, (index) => 'Cocktail ${index + 1}');
  late Future<List<Cocktail>> _cocktails;
  final AuthenticationService _authService = AuthenticationService();

  final List<String> mycocktail = List.generate(10, (index) => 'My Cocktail ${index + 1}');

  @override
  void initState() {
    super.initState();
    _cocktails = _authService.fetchCocktails();
  }

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
            FutureBuilder<List<Cocktail>>(
              future: _cocktails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(child: Text('No cocktails found'));
                } else {
                  return Container(
                    height: 180.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        Cocktail cocktail = snapshot.data![index];
                        return GestureDetector(
                          onTap: () => _showCocktailDetails(context, cocktail),
                          child: Container(
                            width: 160.0,
                            child: Card(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(cocktail.name, style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 8),
                                    Text(cocktail.explanation),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('내가 만든 칵테일입니다', style: Theme.of(context).textTheme.headline6),
            ),
            Container(
              height: 180.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mycocktail.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: 160.0,
                    child: Card(
                      child: Center(
                        child: Text(mycocktail[index]),
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

  void _showCocktailDetails(BuildContext context, Cocktail cocktail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(cocktail.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('설명: ${cocktail.explanation}'),
                Text('재료: ${cocktail.ingredients}'),
                Text('제조법: ${cocktail.recipe}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('닫기'),
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