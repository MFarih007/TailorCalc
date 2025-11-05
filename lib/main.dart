import 'package:flutter/material.dart';
// import 'package:tailor_calc/settings.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:tailor_calc/pages/newcalc.dart';
import 'package:tailor_calc/pages/pricinghistory.dart';
import 'package:tailor_calc/pages/settings.dart';
import 'package:tailor_calc/pages/templatelibrary.dart';
import 'package:tailor_calc/database/price_database.dart';
import 'package:tailor_calc/models/pricinghistoryrecord.dart';

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
  final PriceDatabase _database = PriceDatabase();
  int _totalJobs = 0;
  double _avgProfitMargin = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final List<PricingHistoryRecord> history = await _database.readAllHistory();
      final int total = history.length;
      double avg = 0;
      if (total > 0) {
        double sum = 0;
        for (final h in history) {
          sum += h.inputs.profitMarginPct;
        }
        avg = sum / total;
      }
      if (mounted) {
        setState(() {
          _totalJobs = total;
          _avgProfitMargin = avg;
        });
      }
    } catch (e) {
      // Keep defaults on error
    }
  }

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
          Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Jobs', style: TextStyle(color: Colors.grey[700])),
                      SizedBox(height: 6),
                      Text(_totalJobs.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Avg Profit Margin', style: TextStyle(color: Colors.grey[700])),
                      SizedBox(height: 6),
                      Text('${_avgProfitMargin.toStringAsFixed(1)}%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
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
