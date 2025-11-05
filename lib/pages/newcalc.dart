import 'package:flutter/material.dart';
import 'package:tailor_calc/pages/result.dart';
import 'package:flutter/services.dart';
import 'package:tailor_calc/utils/settings_helper.dart';

class NewCalcPage extends StatefulWidget {
	const NewCalcPage({super.key, this.initialInput});

  final Map<String, dynamic>? initialInput;

	@override
	State<NewCalcPage> createState() => _NewCalcPageState();
}

class _NewCalcPageState extends State<NewCalcPage> {

  final _calcformkey = GlobalKey<FormState>();
  late Map<String, dynamic> input;

  @override
  void initState() {
    super.initState();
    // Initialize input with template data or defaults
    input = widget.initialInput ?? {
      'outfitName': '',
      'category': '',
      'fabric': 0,
      'lining': 0,
      'accessories': 0,
      'laborHours': 0,
      'laborRate': 0,
      'transportMisc': 0,
      'overhead': 0,
      'profitMarginPct': 0,
    };
  }

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
				title: Text('New Calculation'),
			),
			body: SafeArea(
				child: Form(
          key: _calcformkey,
          child: ListView(
            padding: const EdgeInsets.all(30.0),
            children: [
              Text('Job Details'),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildTextField('Outfit Name', 'outfitName'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: _buildTextField('Category', 'category'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text('Material Costs'),
              SizedBox(height: 12),
              _buildNumberField('Fabric', 'fabric'),
              SizedBox(height: 12),
              _buildNumberField('Lining', 'lining'),
              SizedBox(height: 12),
              _buildNumberField('Accessories', 'accessories'),
              SizedBox(height: 12),
              Text('Labor & Overhead'),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildNumberField('Labor Hours', 'laborHours'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: _buildNumberField('Labor Rate', 'laborRate'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildNumberField('Transport/Misc', 'transportMisc'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: _buildNumberField('Overhead', 'overhead'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text('Profit Margin'),
              SizedBox(height: 12),
              _buildProfitMarginField(),
              SizedBox(height: 12),
              _buildCalculateButton(),
            ],
          )
				),
			),
		);
	}

  Widget _buildTextField(title, value) { // Text Field Widget
    return TextFormField(
      initialValue: input[value]?.toString() ?? '',
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder()
      ),
      validator: (value) => value!.isEmpty || value.length > 60 ? '1-60 chars' : null,
      onChanged:(newValue) => input[value] = newValue,
    );
  }

  Widget _buildNumberField(title, value) { // Number Field Widget
    final initialValue = input[value] ?? 0.0;
    return TextFormField(
      initialValue: initialValue > 0 ? initialValue.toString() : '',
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder()
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
      ],
      validator: (value) => double.tryParse(value!) == null || double.parse(value) < 0 ? 'Enter a valid number ≥ 0' : null,
      onChanged:(newValue) {
        if (newValue.isNotEmpty) {
          input[value] = double.tryParse(newValue) ?? 0.0;
        } else {
          input[value] = 0.0;
        }
      }
    );
  }

  Widget _buildProfitMarginField() { // Profit Margin Field with default hint
    final defaultMargin = SettingsHelper.getDefaultMargin();
    final initialValue = input['profitMarginPct'] ?? 0.0;
    return TextFormField(
      initialValue: initialValue > 0 ? initialValue.toString() : '',
      decoration: InputDecoration(
        labelText: 'Profit Margin (%)',
        hintText: 'Default: ${defaultMargin.toStringAsFixed(1)}%',
        border: OutlineInputBorder(),
        helperText: 'Leave empty to use default (${defaultMargin.toStringAsFixed(1)}%)',
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return null; // Empty is allowed (will use default)
        }
        final parsed = double.tryParse(value);
        if (parsed == null || parsed < 0 || parsed > 95) {
          return 'Valid percentage between 0-95';
        }
        return null;
      },
      onChanged: (newValue) {
        if (newValue.isNotEmpty) {
          input['profitMarginPct'] = double.tryParse(newValue) ?? 0.0;
        } else {
          input['profitMarginPct'] = 0.0; // Will use default in calculation
        }
      }
    );
  }

  Widget _buildCalculateButton() {
    return MaterialButton(
      color: Colors.blue,
      textColor: Colors.white,
      minWidth: 100,
      height: 50,
      onPressed: () => {
        if (_calcformkey.currentState!.validate()) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return ResultPage(
                  result: _calculate(),
                  input: input
                );
              }
            )
          )
        },
      },
      child: Text('Calculate Price')
    );
  }
  
  Map<String, dynamic> _calculate() {
    double fabric = input['fabric'] ?? 0.0;
    double lining = input['lining'] ?? 0.0;
    double accessories = input['accessories'] ?? 0.0;
    double laborHours = input['laborHours'] ?? 0.0;
    double laborRate = input['laborRate'] ?? 0.0;
    double transportMisc = input['transportMisc'] ?? 0.0;
    double overhead = input['overhead'] ?? 0.0;
    
    // Use profit margin from input if provided, otherwise use default from settings
    double profitMarginPct = (input['profitMarginPct'] != null && input['profitMarginPct'] > 0)
        ? input['profitMarginPct']
        : SettingsHelper.getDefaultMargin();
    
    // Calculate totals
    double materialsTotal = fabric + lining + accessories;
    
    // Calculate labor total
    double laborTotal = laborHours * laborRate;
    
    // Calculate overhead total
    double overheadTotal = transportMisc + overhead;
    
    double costTotal = materialsTotal + laborTotal + overheadTotal;
    double profitAmount = costTotal * (profitMarginPct / 100);
    double sellingPrice = costTotal + profitAmount;

    return {
      'materialsTotal': materialsTotal,
      'laborTotal': laborTotal,
      'overheadTotal': overheadTotal,
      'costTotal': costTotal,
      'sellingPrice': sellingPrice,
      'profitAmount': profitAmount,
      'profitMarginPct': profitMarginPct,
    };
  }
}