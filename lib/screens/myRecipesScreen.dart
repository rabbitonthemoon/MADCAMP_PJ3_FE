import 'package:flutter/material.dart';
import 'package:pj3/main.dart';
import '/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pj3/screens/mixScreen.dart';
import 'package:pj3/screens/cocktailsScreen.dart';
import 'package:pj3/services/authenticationService.dart';
import 'package:fluttertoast/fluttertoast.dart';

const apiKey = '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';
const apiUrl = 'https://api.openai.com/v1/completions';
var imageUrl="";
String resultText = ''; // 결과 텍스트를 저장할 변수

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  List<MyCocktail> cocktails = [];

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

  final List<String> maincocktail = List.generate(20, (index) => 'Cocktail $index');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _username = "게스트";
  bool _isLoggedIn = false;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;
  var loading = false;
  String imageUrl = "";
  String resultText = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void generateImage(String prompt) async {
    setState(() {
      loading = true;
    });

    final uri = Uri.parse('https://api.openai.com/v1/images/generations');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    };
    final body = jsonEncode({
      'model': 'dall-e-3',
      'prompt': 'make cocktail use given ingredients($prompt), you can add at most 1 more ingredients if you nedd',
      'size': '1024x1024',
      'quality': 'standard',
      'n': 1,
    });
    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final image_url = responseData['data'][0]['url'];
        print('Image URL: $image_url');

        setState(() {
          imageUrl = image_url;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        print('Failed to generate image: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        loading = true;
      });
    }
  }

  void generateText(String prompt) async {
      setState(() {
        isLoading = true; // 로딩 시작
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey'
        },
        body: jsonEncode
          ({
          "model": "gpt-3.5-turbo-instruct",
          //'prompt': "make cocktail use given ingredients($prompt). you can add just one more ingredients if needed. And give me 4 contents using korean(not english) 1.name of cocktail you made. 2. ingredients you used 3.simple explanation of cocktail you made",
          'prompt': "$prompt. 이 재료들을 사용해서 1개의 칵테일을 만들어. 만든 칵테일에 대한 설명을 출력 형식에 맞춰 보여줘. 출력형식:(이름\n설명\n재료\n레시피) 이렇게 4개를 각각 1줄로 작성해줘. 그리고 반드시 한국어로 작성해줘",
          'max_tokens': 300,
          'temperature': 0,
          'top_p': 1,
          'frequency_penalty': 1,
          'presence_penalty': 1
        }),
      );


      if (response.statusCode == 200) {
        final newResponse = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          resultText = newResponse['choices'][0]['text']; // 결과 텍스트 업데이트
          isLoading = false; // 로딩 종료
        });
      } else {
        print('Failed to generate text: ${response.body}');
        setState(() {
          isLoading = false; // 오류 발생 시 로딩 종료
        });
      }
    }

  void generateContent(String prompt){
    generateImage(prompt);
    generateText(prompt);
  }



  void _loadUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String username = prefs.getString('userName') ?? "게스트";
    print("Loaded username: $username"); 

    setState(() {
    _isLoggedIn = isLoggedIn;
    _username = username;
    });
  }

  void _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userName');

    setState(() {
    _isLoggedIn = false;
    _username = "게스트";
    imageUrl = "";
    resultText = "";
    _controller.clear();
    });

    Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => MainScreen()), 
    (Route<dynamic> route) => false
  );
  }
  //여기부터
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          _isLoggedIn 
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.exit_to_app, color: Color(0xFFFBEAFC)),
                      onPressed: _logout,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/main_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: _isLoggedIn ? _buildLoggedInView() : _buildLoggedOutView(),
      ),
    );
  }


  void uploadCockData(String name, String explanation, String ingredients, String recipe) async {
  final url = 'http://143.248.226.38:8080/mycock/addCock'; // 실제 서버 URL로 대체하세요

  final cockData = {
    'name': name,
    'explanation': explanation,
    'ingredients': ingredients,
    'recipe': recipe,
    'cockImg': imageUrl,
    'recommend': 1,
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cockData),
    );

    if (response.statusCode == 200) {
      print('Cock data uploaded successfully');

      // 새로운 칵테일 객체를 생성하고 리스트에 추가
      MyCocktail newCocktail = MyCocktail(
        name: name,
        explanation: explanation,
        ingredients: ingredients,
        recipe: recipe,
        cockImg: imageUrl,
        recommend: 1,
      );

      setState(() {
        cocktails.add(newCocktail);
      });

      Fluttertoast.showToast(
        msg: "레시피가 등록되었습니다", // 메시지 변경
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );


    } else {
      print('Failed to upload cock data: ${response.body}');
    }
  } catch (e) {
    print('Error during cock data upload: $e');
  }
}


  Widget _buildLoggedOutView() {
    return Center( 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '로그인 후 서비스를 이용하세요',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: RichText(
              text: TextSpan(
                text: '로그인/회원가입',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedInView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0).copyWith(
        top: MediaQuery.of(context).padding.top + AppBar().preferredSize.height + 10),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            // padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 20),
            child: Text(
              '$_username님, 환영합니다',
              style: TextStyle(
                color: Color(0xFFFBEAFC),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 40), 
          
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "재료를 입력하세요",
              border: OutlineInputBorder(),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          const SizedBox(height: 10),

          TextButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                generateContent(_controller.text); 
              }
            },
            child: const Text(
              "나만의 칵테일 만들기",
              style: TextStyle(color: Color(0xFFFBEAFC)),
            ),
          ),
          const SizedBox(height: 10),
          loading
              ? const CircularProgressIndicator()
              : imageUrl.isNotEmpty
                  ? Image.network(imageUrl)
                  : Container(),
          const SizedBox(height: 10),
          isLoading
            ? const CircularProgressIndicator()
              : Text(
                  resultText,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: (imageUrl.isNotEmpty && resultText.isNotEmpty) ? () {
              List<String> splitResult = resultText.split('\n');
              if (splitResult.length >= 4) {
                String name = splitResult[0];
                String explanation = splitResult[2];
                String ingredients = splitResult[1];
                String recipe = splitResult[3];

                print('Name: $name');
                print('Explanation: $explanation');
                print('Ingredients: $ingredients');
                print('Recipe: $recipe');

                uploadCockData(name, explanation, ingredients, recipe);
              } 
            } : null,
            child: const Text(
              "칵테일 등록하기",
              style: TextStyle(color: Color(0xFFFBEAFC)),
            ),
          ),
          const SizedBox(height: 250),
        ],
      ),
    );
  }

  Widget buildCocktailCard(MyCocktail cocktail) {
  return Card(
    child: Column(
      children: [
        Image.network(cocktail.cockImg),
        Text(cocktail.name),
        Text(cocktail.explanation),
        Text('Ingredients: ${cocktail.ingredients}'),
        Text('Recipe: ${cocktail.recipe}'),
      ],
    ),
  );
}

Widget buildCocktailList() {
  return ListView.builder(
    itemCount: cocktails.length,
    itemBuilder: (context, index) {
      return buildCocktailCard(cocktails[index]);
    },
  );
}

}