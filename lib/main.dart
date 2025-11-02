import 'package:flutter/material.dart';
// import 'package:tailor_calc/settings.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Settings.init(cacheProvider: SharePreferenceCache());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   // primaryColor: Color(0xFF001F3F),
      //   primarySwatch: Colors.blue,
      // ),
      home: const HomeScreen(title: 'TailorCalc'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
        ),
      ),
    );
  }
}
