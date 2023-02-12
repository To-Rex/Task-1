import 'dart:async';

import 'package:flutter/material.dart';
import 'fragmentTab/history_page.dart';
import 'fragmentTab/home_page.dart';
import 'fragmentTab/settings_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  var count;
  MyApp({super.key, this.count});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MyCounter(),
      ),
    );
  }
}

class MyCounter extends StatefulWidget {
  set count(int count) {
    _MyCounterState()._counter = count;
  }

  @override
  _MyCounterState createState() => _MyCounterState();

  int getCounter(BuildContext context) {
    final _MyCounterState? state = context.findAncestorStateOfType<_MyCounterState>();
    return state!._counter;
  }

}

class _MyCounterState extends State<MyCounter> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    HistoryPage(),
    SettingsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
      widget.count = _counter;
    }else if (state == AppLifecycleState.paused) {
      print('paused');
      startTimer();
      _counter++;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1.0),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restore),
            activeIcon: Icon(Icons.restore),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        elevation: 5,
        selectedItemColor: Colors.white,
        selectedIconTheme: const IconThemeData(color: Colors.indigo),
        onTap: _onItemTapped,
      ),
    );
  }
}
