import 'package:flutter/material.dart';

class PricingHistoryPage extends StatefulWidget {
	const PricingHistoryPage({super.key});

	@override
	State<PricingHistoryPage> createState() => _PricingHistoryPageState();
}

class _PricingHistoryPageState extends State<PricingHistoryPage> {

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
				title: Text('Pricing History'),
			),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(30.0),
          children: [
            DataTable(
              columns: const <DataColumn> [
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Date',
                    )
                  )
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Outfit Name',
                    )
                  )
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Margin',
                    )
                  )
                ),
              ],
              rows: const <DataRow> [
                DataRow(
                  cells: <DataCell> [
                    DataCell(Text('11/08/2025')),
                    DataCell(Text('Manis')),
                    DataCell(Text('17,700%'))
                  ]
                ),
              ]
            ),
            SizedBox(height: 30),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () => {},
              minWidth: 100,
              height: 50,
              child: Icon(Icons.menu),
            )
          ],
        )
      )
		);
	}
}
