import 'package:flutter/material.dart';
import 'package:tailor_calc/database/price_database.dart';
import 'package:tailor_calc/models/pricinghistoryrecord.dart';

class PricingHistoryPage extends StatefulWidget {
	const PricingHistoryPage({super.key});

	@override
	State<PricingHistoryPage> createState() => _PricingHistoryPageState();
}

class _PricingHistoryPageState extends State<PricingHistoryPage> {

  final PriceDatabase db = PriceDatabase();
  List<PricingHistoryRecord> histories = [];

  Future<void> loadHistory() async {
    final histories = await db.readAllHistory();
    setState(() {
      this.histories = histories;
    });
  }

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

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
                      'Price',
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
              rows: histories.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item.createdAt.toString())),
                    DataCell(Text(item.outfitName)),
                    DataCell(Text(item.computed.sellingPrice.toString())),
                    DataCell(Text(item.inputs.profitMarginPct.toString()))
                  ]
                );
              }).toList()
            ),
            // Text('No Pricing History'),
            ?histories.isEmpty ? Text('No Pricing History', textAlign: TextAlign.center) : null,
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
