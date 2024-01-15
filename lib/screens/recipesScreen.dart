import 'package:flutter/material.dart';
import 'package:pj3/services/authenticationService.dart';

class RecipesScreen extends StatefulWidget {
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> with SingleTickerProviderStateMixin {
  // 임의의 데이터 리스트
  // final List<String> cocktail = List.generate(10, (index) => 'Cocktail ${index + 1}');
  late Future<List<Cocktail>> _cocktails;
  late TabController _tabController;
  final AuthenticationService _authService = AuthenticationService();
  final List<String> mycocktail = List.generate(10, (index) => 'My Cocktail ${index + 1}');

  @override
  void initState() {
    super.initState();
    _cocktails = _authService.fetchCocktails();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color(0xFF241D49),
          elevation:  0,
          title: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'STEADY'),
              Tab(text: 'MY'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFFB8B8B8),
            indicatorColor: Colors.transparent,
            // indicatorPadding: EdgeInsets.zero,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/recipes_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildCocktailsTab(),
            _buildMyCocktailsTab(),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildCocktailsTab() {
    return Padding(
    padding: EdgeInsets.all(20),
    child: FutureBuilder<List<Cocktail>>(
      future: _cocktails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(child: Text('No cocktails found'));
        } else {
          return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: (140 / 160), 
            crossAxisSpacing:10,
            mainAxisSpacing: 10, 
          ),
          itemCount: snapshot.data!.length,
          itemBuilder: (BuildContext context, int index) {
            Cocktail cocktail = snapshot.data![index];
            return GestureDetector(
              onTap: () => _showCocktailDetails(context, cocktail),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Image.network(
                          cocktail.cockimg,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(cocktail.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(cocktail.explanation),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    },
  )
  );
}

Widget _buildMyCocktailsTab() {
    return GridView.builder(
      padding: EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (140 / 160),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: mycocktail.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(mycocktail[index]),
          ),
        );
      },
    );
  }



//   Widget _buildMyCocktailsTab() {
//   return Padding( 
//     padding: EdgeInsets.symmetric(horizontal: 2), 
//     child: GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: (140 / 160),
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 8, 
//       ),
//       itemCount: mycocktail.length,
//       itemBuilder: (BuildContext context, int index) {
//         return Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(4), // 코너 반경 설정
//           ),
//           child: Center(
//             child: Text(mycocktail[index]),
//           ),
//         );
//       },
//     ),
//   );
// }


  void _showCocktailDetails(BuildContext context, Cocktail cocktail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(cocktail.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.network(cocktail.cockimg, fit: BoxFit.cover),
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