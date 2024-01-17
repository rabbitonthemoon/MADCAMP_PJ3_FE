import 'package:flutter/material.dart';
import 'screens/myRecipesScreen.dart';
import 'screens/cocktailsScreen.dart';
import 'screens/mixScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Pocket Bartender',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  final List<Widget> _widgetOptions = [
    RecipesScreen(),
    CreateScreen(),
    HomeScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    extendBody: true,
    body: Center(
      child: _widgetOptions.elementAt(_selectedIndex),
    ),
    bottomNavigationBar: ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Cocktails',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Best',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_bar),
              label: 'My Recipes',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.white.withOpacity(0.6), 
          backgroundColor: Color(0xFF241D49), 
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          // selectedItemColor: Color(0xFFFBEAFC),
          // backgroundColor: Color(0xE5241D49),
          // elevation: 0,
        ),
      ),
    ),
  );
}
}