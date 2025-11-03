import 'package:flutter/material.dart';

class TemplateLibraryPage extends StatefulWidget {
	const TemplateLibraryPage({super.key});

	@override
	State<TemplateLibraryPage> createState() => _TemplateLibraryPageState();
}

class _TemplateLibraryPageState extends State<TemplateLibraryPage> {

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
				title: Text('Saved  Templates'),
			),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(30.0),
          children: [
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () => {},
              minWidth: 100,
              height: 50,
              child: Text('New Template'),
            )
          ],
        )
      )
		);
	}
}
