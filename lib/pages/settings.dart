import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:tailor_calc/utils/settings_helper.dart';

class SettingsPage extends StatefulWidget {
	const SettingsPage({super.key});

	@override
	State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
	@override
	void initState() {
		super.initState();
		// Load current values
		WidgetsBinding.instance.addPostFrameCallback((_) {
			setState(() {});
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				backgroundColor: Colors.blue,
				foregroundColor: Colors.white,
				title: Text('Settings'),
			),
			body: SafeArea(
				child: ListView(
					padding: const EdgeInsets.all(16.0),
					children: [
						// Currency Section
						_settingsSection(
							title: 'Currency',
							children: [
								DropDownSettingsTile<int>(
									settingKey: SettingsHelper.currencyKey,
									selected: _getCurrencyIndex(),
									title: 'Select Currency',
									values: const <int, String> {
										1: 'NGN (₦)',
										2: 'USD (\$)',
										3: 'EUR (€)',
										4: 'GBP (£)',
										5: 'GHS (₵)',
									},
									onChange: (value) {
										SettingsHelper.setCurrency(value);
										setState(() {});
									},
								),
							],
						),
						
						// Default Margin Section
						_settingsSection(
							title: 'Default Profit Margin',
							children: [
								TextInputSettingsTile(
									title: 'Default Margin (%)',
									settingKey: SettingsHelper.defaultMarginKey,
									initialValue: SettingsHelper.getDefaultMargin().toString(),
									keyboardType: TextInputType.numberWithOptions(decimal: true),
									onChange: (value) {
										final margin = double.tryParse(value);
										if (margin != null && margin >= 0 && margin <= 100) {
											SettingsHelper.setDefaultMargin(margin);
										}
									},
								),
								// Padding(
								// 	padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
								// 	child: Text(
								// 		'Current: ${SettingsHelper.getDefaultMargin().toStringAsFixed(1)}%',
								// 		style: TextStyle(
								// 			fontSize: 12,
								// 			color: Colors.grey[600],
								// 		),
								// 	),
								// ),
							],
						),
						
						// Branding Section
						_settingsSection(
							title: 'Branding',
							children: [
								TextInputSettingsTile(
									title: 'Brand Name',
									settingKey: SettingsHelper.brandNameKey,
									initialValue: SettingsHelper.getBrandName(),
									// hint: 'Enter your brand name',
									onChange: (value) {
										if (value.isNotEmpty) {
											SettingsHelper.setBrandName(value);
										}
									},
								),
								TextInputSettingsTile(
									title: 'Prepared By',
									settingKey: SettingsHelper.preparedByKey,
									initialValue: SettingsHelper.getPreparedBy(),
									// hint: 'Enter your name or business name',
									onChange: (value) {
										SettingsHelper.setPreparedBy(value);
									},
								),
							],
						),
					],
				),
			),
		);
	}

	int _getCurrencyIndex() {
		final currency = SettingsHelper.getCurrency();
		final currencies = ['NGN', 'USD', 'EUR', 'GBP', 'GHS'];
		final index = currencies.indexOf(currency);
		return index >= 0 ? index + 1 : 1;
	}

	Widget _settingsSection({
		required String title,
		required List<Widget> children,
	}) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Padding(
					padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
					child: Text(
						title,
						style: TextStyle(
							fontSize: 18,
							fontWeight: FontWeight.bold,
							color: Colors.blue[700],
						),
					),
				),
				Card(
					margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
					child: Column(
						children: children,
					),
				),
				SizedBox(height: 16),
			],
		);
	}
}
