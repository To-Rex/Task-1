import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fragmentTab/history_page.dart';
import 'fragmentTab/home_page.dart';
import 'fragmentTab/settings_page.dart';

var counters;

late Timer _timer;

class SamplePage extends StatefulWidget {
  var counter;

  SamplePage({Key? key, this.counter}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

  Future<void> onStop() async {
    print("onStop() called $counters");
    WidgetsFlutterBinding.ensureInitialized();
    final service = FlutterBackgroundService();
    initializeService();
    service.sendData(
      {"action": "stopService"},
    );
  }

  Future<void> startService() async {
    print("startService() called $counters");
    WidgetsFlutterBinding.ensureInitialized();
    final service = FlutterBackgroundService();
    initializeService();
    service.start();
  }

}

class _HomePageState extends State<SamplePage> with WidgetsBindingObserver {
  String text = "Start Service";

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

  final service = FlutterBackgroundService();

  @override
  void initState() {
    WidgetsBinding.instance.removeObserver(this);
    super.initState();
    initializeService();
    service.sendData(
      {"action": "stopService"},
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print('resumed');
        initializeService();
        service.sendData(
          {"action": "stopService"},
        );
        break;
      case AppLifecycleState.inactive:
        print('inactive');
        break;
      case AppLifecycleState.paused:
        print('paused');
        initializeService();
        service.start();
        break;
      case AppLifecycleState.detached:
        print('detached');
        initializeService();
        service.start();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeService();
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

/// ********************* service settings************************ \\\

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,
      // auto start service
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
}

Future<void> onStart() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  final prefs = await SharedPreferences.getInstance();
  counters = prefs.getInt('counter') ?? 0;
  print('onStart ${counters}');
  counters + 1;
  service.onDataReceived.listen((event) {
    switch (event!["action"]) {
      case "setAsForeground":
        service.setForegroundMode(true);
        break;
      case "setAsBackground":
        service.setForegroundMode(false);
        break;
      case "stopService":
        service.stopBackgroundService();
        break;
    }
  });

  _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();
    print('timer ${counters}');
    counters++;
    prefs.setInt('counter', counters);
  });
  service.setForegroundMode(true);
}
