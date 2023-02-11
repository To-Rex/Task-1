import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {


  int _counter = 1;
  var _timer;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _counter++;
      });
    });
  }


  @override
  void initState() {
    
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // here the desired height
        child: AppBar(
          backgroundColor: const Color.fromRGBO(33, 158, 188, 10),
        ),
      ),
      /*body: Center(
        child: Text('Counter: $_counter'),
      ),*/
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$_counter da to`xtatilgan'),
          const SizedBox(height: 10,),
          Center(
            child: Text('Counter: $_counter'),
          ),
        ],
      )
    );
  }
}