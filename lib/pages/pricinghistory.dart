import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tailor_calc/database/price_database.dart';
import 'package:tailor_calc/models/pricinghistoryrecord.dart';
import 'package:tailor_calc/utils/settings_helper.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear History',
            onPressed: _confirmClearHistory,
          )
        ],
			),
      body: SafeArea(
        child: histories.isEmpty
            ? Center(
                child: Text('No Pricing History', style: TextStyle(color: Colors.grey[600])),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: histories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = histories[index];
                  final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(item.createdAt);
                  final priceStr = SettingsHelper.formatCurrency(item.computed.sellingPrice);
                  final marginStr = '${item.inputs.profitMarginPct.toStringAsFixed(1)}%';

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(item.outfitName),
                      subtitle: Text('$dateStr • $marginStr'),
                      trailing: Text(priceStr, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              )
      )
		);
	}

  void _confirmClearHistory() async {
    if (histories.isEmpty) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to delete all history?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await db.clearHistory();
      await loadHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('History cleared')),
        );
      }
    }
  }
}
