import 'package:flutter/material.dart';
// import 'package:tailor_calc/settings.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:tailor_calc/pages/newcalc.dart';
import 'package:tailor_calc/pages/pricinghistory.dart';
import 'package:tailor_calc/pages/settings.dart';
import 'package:tailor_calc/pages/templatelibrary.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(title: 'TailorCalc'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

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
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,

        title: Text('Home'),
        actions: [
          IconButton(
            // color: Colors.white,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SettingsPage()
              )
            ),
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          ),
        ]
      ),
      body: ListView(
        padding: const EdgeInsets.all(30.0),
        children: [
          MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            minWidth: 100,
            height: 100,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NewCalcPage()
              )
            ),
            child: Column(
              children: [
                Icon(Icons.add),
                Text('New Calculation')
              ]
            )
          ),
          SizedBox(height: 30),
          MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            minWidth: 100,
            height: 100,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TemplateLibraryPage()
              )
            ),
            child: Column(
              children: [
                Icon(Icons.folder),
                Text('Saved Templates')
              ]
            )
          ),
          SizedBox(height: 30),
          MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            minWidth: 100,
            height: 100,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PricingHistoryPage()
              )
            ),
            child: Text('Campicay Ofum')
          )
        ]
      ),
    );
  }
}
