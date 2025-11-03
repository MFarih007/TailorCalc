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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Outfit Name',
                  border: OutlineInputBorder()
                ),
                validator: (value) => value!.isEmpty || value.length > 60 ? '1-60 chars' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 20),
              Text('Material Costs'),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Fabric',
                  border: OutlineInputBorder()
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
                validator: (value) => double.tryParse(value!) == null || double.parse(value) < 0 ? 'Valid number >= 0' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Lining',
                  border: OutlineInputBorder()
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
                validator: (value) => double.tryParse(value!) == null || double.parse(value) < 0 ? 'Valid number >= 0' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Accessories',
                  border: OutlineInputBorder()
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
                validator: (value) => double.tryParse(value!) == null || double.parse(value) < 0 ? 'Valid number >= 0' : null,
              ),
              SizedBox(height: 20),
              Text('Labor & Overhead'),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Talior Hours',
                  border: OutlineInputBorder()
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
                validator: (value) => double.tryParse(value!) == null || double.parse(value) < 0 ? 'Valid number >= 0' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Transport/Misc.',
                  border: OutlineInputBorder()
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
                validator: (value) => double.tryParse(value!) == null || double.parse(value) < 0 ? 'Valid number >= 0' : null,
              ),
              SizedBox(height: 20),
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                minWidth: 100,
                height: 50,
                onPressed: () => {
                  if (_calcformkey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultPage()
                      )
                    )
                  },
                },
                child: Text('Calculate Price')
              )
            ],
          )
				),
			),
		);
	}
}
