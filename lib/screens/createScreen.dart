import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('칵테일을 만듭시다'),
      ),
      body: Center(
        child: Text(
          '!',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}
