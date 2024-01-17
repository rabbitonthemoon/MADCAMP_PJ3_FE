import 'package:flutter/material.dart';
import 'package:pj3/services/authenticationService.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RecipesScreen extends StatefulWidget {
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> with SingleTickerProviderStateMixin {
  late Future<List<Cocktail>> _cocktails;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  final AuthenticationService _authService = AuthenticationService();

  @override
  void initState() {
    super.initState();
    _cocktails = _authService.fetchCocktails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Color(0xFFFBEAFC)),
            onPressed: () async {
              final cocktails = await _cocktails;
              final selectedIndex = await showSearch<int?>(
                context: context,
                delegate: CocktailSearchDelegate(cocktails),
              );
              if (selectedIndex != null && selectedIndex >= 0) {
                _pageController.animateToPage(
                  selectedIndex,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            },
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
        child: _buildCocktailsTab(),
      ),
    );
  }

  //여기부터
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
            return PageView.builder(
              controller: _pageController,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                Cocktail cocktail = snapshot.data![index];
                return AnimatedBuilder(
                  animation: _pageController, 
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
                    }
                    return Center(
                      child: SizedBox(
                        height: Curves.easeOut.transform(value) * 380,
                        width: Curves.easeOut.transform(value) * 360,
                        child: FlipCard(
                          front: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(cocktail.cockImg, fit: BoxFit.cover),
                          ),
                          back: CardInfo(cocktail: cocktail),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;

  FlipCard({required this.front, required this.back});

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool _isFront = true;

  void _flipCard() {
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: _flipCard,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: _isFront ? 0 : 3.1415),
          duration: Duration(milliseconds: 500), 
          builder: (BuildContext context, double val, __) {
            return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(val),
            child: val >= (3.1415 / 2)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(3.1415),
                      child: widget.back,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: widget.front,
                  ),
          );
        },
      ),
    );
  }
}

class CardInfo extends StatelessWidget {
  final Cocktail cocktail;

  CardInfo({required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              cocktail.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF241D49)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Text(
              cocktail.explanation,
              style: TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Text(
              'Ingredients: ${cocktail.ingredients}',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Text(
              'Recipe: ${cocktail.recipe}',
              style: TextStyle(fontSize: 12),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}


class CocktailSearchDelegate extends SearchDelegate<int?> {
  final List<Cocktail> cocktails;

  CocktailSearchDelegate(this.cocktails);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Color(0xFFFBEAFC)),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Cocktail> matchQuery = cocktails.where((cocktail) {
      return cocktail.name.toLowerCase().contains(query.toLowerCase()) ||
             cocktail.explanation.toLowerCase().contains(query.toLowerCase()) ||
             cocktail.ingredients.toLowerCase().contains(query.toLowerCase()) ||
             cocktail.recipe.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final cocktail = matchQuery[index];
        return ListTile(
          title: Text(cocktail.name),
          subtitle: Text(cocktail.explanation),
          onTap: () {
            final selectedCocktailIndex = cocktails.indexOf(cocktail);
            close(context, selectedCocktailIndex);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    return Container();
  }
}
