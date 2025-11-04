import 'package:flutter/material.dart';
import 'package:tailor_calc/pages/result.dart';
import 'package:flutter/services.dart';

class NewCalcPage extends StatefulWidget {
	const NewCalcPage({super.key});

	@override
	State<NewCalcPage> createState() => _NewCalcPageState();
}

class _NewCalcPageState extends State<NewCalcPage> {

  final _calcformkey = GlobalKey<FormState>();

  Map<String, dynamic> input = {
    'outfitName': '',
    'category': '',
    'fabric': 0,
    'lining': 0,
    'accessories': 0,
    'laborHours': 0,
    'transportMisc': 0
  };

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
              SizedBox(height: 20),
              _buildTextField('Outfit Name', 'outfitName'),
              SizedBox(height: 20),
              _buildTextField('Category', 'category'),
              SizedBox(height: 20),
              Text('Material Costs'),
              SizedBox(height: 20),
              _buildNumberField('Fabric', 'fabric'),
              SizedBox(height: 20),
              _buildNumberField('Lining', 'lining'),
              SizedBox(height: 20),
              _buildNumberField('Accessories', 'accessories'),
              SizedBox(height: 20),
              Text('Labor & Overhead'),
              SizedBox(height: 20),
              _buildNumberField('Labor Hours', 'laborHours'),
              SizedBox(height: 20),
              _buildNumberField('Transport/Misc', 'transportMisc'),
              SizedBox(height: 20),
              _buildCalculateButton(),
            ],
          )
				),
			),
		);
	}

  Widget _buildTextField(title, value) { // Text Field Widget
    return TextFormField(
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder()
      ),
      validator: (value) => value!.isEmpty || value.length > 60 ? '1-60 chars' : null,
      onChanged:(newValue) => input[value] = newValue,
    );
  }

  Widget _buildNumberField(title, value) { // Number Field Widget
    return TextFormField(
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder()
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
      ],
      validator: (value) => double.tryParse(value!) == null || double.parse(value) < 0 ? 'Valid number >= 0' : null,
      onChanged:(newValue) => input[value] = double.parse(newValue)
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
                debugPrint(_calculate()['materialsTotal'].toString());
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
    double fabric = input['fabric'];
    double lining = input['lining'];
    double accessories = input['accessories'];
    double materialsTotal = fabric + lining + accessories;
    // double laborTotal = laborHours! * laborRate;
    // double overheadTotal = transportMisc! + overhead;
    // double costTotal = materialsTotal + laborTotal + overheadTotal;
    // double sellingPrice = costTotal * (profitMarginPct / 100);
    // double profitAmount = sellingPrice - costTotal;

    return {
      'materialsTotal': materialsTotal,
      // 'laborTotal': laborTotal,
      // 'overheadTotal': overheadTotal,
      // 'costTotal': costTotal,
      // 'sellingPrice': sellingPrice,
      // 'profitAmount': profitAmount
    };
  }
}