import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
	const ResultPage({super.key, required this.result});

  final Map<String, dynamic> result;

	@override
	State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
				title: Text('Calculation Result'),
			),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(30.0),
          children: [
            Text('Material Cost'),
            SizedBox(height: 30),
            Text('Labor + Overhead'),
            SizedBox(height: 30),
            Text('Profit (20%)'),
            SizedBox(height: 30),
            Text('Suggested Selling Price'),
            SizedBox(height: 30),
            Text(
              '₦XX,XXX',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 30),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () => {},
              minWidth: 100,
              height: 50,
              child: Text('Save as Template'),
            ),
            SizedBox(height: 30),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () => {},
              minWidth: 100,
              height: 50,
              child: Text('Share Quote'),
            )
          ],
        )
      )
		);
	}
}
