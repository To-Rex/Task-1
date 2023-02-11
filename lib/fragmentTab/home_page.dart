import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {

  int _counter = 1;
  var _timer;
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _counter++;
      print('$_counter');
    });
  }

  void stopTimer() {
    setState(() {});
    _timer.cancel();
    print('stopTimer');
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _counter = _counter;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('resumed');
      stopTimer();
    }else if (state == AppLifecycleState.paused) {
      print('paused');
      startTimer();
      _counter++;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // here the desired height
        child: AppBar(
          backgroundColor: const Color.fromRGBO(33, 158, 188, 10),
        ),
      ),
      body: Center(
        child: Text('Counter: $_counter'),
      ),
    );
  }
}