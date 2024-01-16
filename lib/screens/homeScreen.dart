import 'package:flutter/material.dart';
import '/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> maincocktail = List.generate(20, (index) => 'Cocktail $index');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _username = "게스트";
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _username = prefs.getString('userName') ?? "게스트";
    });
  }

  void _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userName');
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.menu, size: 30.0, color: Color(0xFFFBEAFC)),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/main_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 20),
                  child: Text(
                    'Your \nPocket Bartender',
                    style: TextStyle(
                      color: Color(0xFFFBEAFC),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 여기부터
                Flexible(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: maincocktail.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: 160.0,
                        child: Card(
                          child: Center(
                            child: Text(maincocktail[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      endDrawer: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        child: SizedBox(
          width: 260,
          child: Drawer(
            child: Container(
                color: Color(0xFF241D49),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0x9914102A),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(24)),
                          ),
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                icon: Icon(Icons.close, color: Color(0xFFFBEAFC)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                        ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0x9914102A),
                    ),
                    child: ListTile(
                      title: Text(_isLoggedIn ? '$_username 님' : '로그인/회원가입', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        if (!_isLoggedIn) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                        } else {
                          _logout();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}