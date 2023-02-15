import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../sample_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  var counters = 1;

  Future<void> _getCounter() async {
    final prefs = await SharedPreferences.getInstance();
    counters = prefs.getInt('counter') ?? 0;
    setState(() {});
    print("+++++++++ $counters +++++++++++");
  }

  @override
  void initState() {
    _getCounter();
    setState(() {});
    WidgetsBinding.instance.addObserver(this);
    super.initState();
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
        SamplePage(counter: 0).onStop();
        _getCounter();
        break;
      case AppLifecycleState.inactive:
        print('inactive');
        _getCounter();
        break;
      case AppLifecycleState.paused:
        print('paused');
        SamplePage(counter: 0).startService();
        break;
      case AppLifecycleState.detached:
        print('detached');
        SamplePage(counter: 0).startService();
        break;
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('Counter: $counters'),
          ),
        ],
      ),
    );
  }
}


