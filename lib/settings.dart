import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsPage extends StatefulWidget {
	const SettingsPage({super.key});

	@override
	State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
	static const String currencyKey = 'currency_key';
	static const String brandNameKey = 'brand_name_key';

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('Settings'),
			),
			body: SafeArea(
				child: ListView(
					padding: const EdgeInsets.all(16.0),
					children: [
						DropDownSettingsTile<int>(
							settingKey: currencyKey,
							selected: 1,
							title: 'Currency',
							values: const <int, String> {
								1: 'NGN',
								2: 'USD',
								3: 'EUR',
								4: 'GBP',
								5: 'GHS',
							},
							onChange: (value) {
								// Handle currency change
								debugPrint('Selected currency index: $value');
							},
						),
						TextInputSettingsTile(
							title: 'Brand Name',
							settingKey: brandNameKey,
              initialValue: 'My Brand',
              onChange: (value) {
                // Handle brand name change
                debugPrint('Brand name changed to: $value');
              }
            ),
            
					],
				),
			),
		);
	}
}
