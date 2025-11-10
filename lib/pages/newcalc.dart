import 'package:flutter/material.dart';
import 'package:tailor_calc/pages/result.dart';
import 'package:flutter/services.dart';
import 'package:tailor_calc/utils/settings_helper.dart';

class MaterialItem {
  String name;
  double length;
  double cost;
  
  MaterialItem({required this.name, required this.length, required this.cost});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'length': length,
      'cost': cost,
    };
  }

  factory MaterialItem.fromJson(Map<String, dynamic> json) {
    return MaterialItem(
      name: json['name'] ?? '',
      length: (json['length'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
    );
  }
}

class TransportItem {
  String location;
  double cost;
  String notes;

  TransportItem({required this.location, required this.cost, required this.notes});

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'cost': cost,
      'notes': notes,
    };
  }

  factory TransportItem.fromJson(Map<String, dynamic> json) {
    return TransportItem(
      location: json['location'] ?? '',
      cost: (json['cost'] as num).toDouble(),
      notes: json['notes'] ?? '',
    );
  }
}

class OverheadItem {
  String type;
  double hours;
  double cost;
  
  OverheadItem({required this.type, required this.hours, required this.cost});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'hours': hours,
      'cost': cost,
    };
  }

  factory OverheadItem.fromJson(Map<String, dynamic> json) {
    return OverheadItem(
      type: json['type'] ?? '',
      hours: (json['hours'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
    );
  }
}

class TailorItem {
  String name;
  double salaryPerMonth;
  double daysPerMonth;
  double hoursPerDay;
  double hoursSpent;
  
  TailorItem({required this.name, required this.salaryPerMonth, required this.daysPerMonth, required this.hoursPerDay, required this.hoursSpent});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'salaryPerMonth': salaryPerMonth,
      'daysPerMonth': daysPerMonth,
      'hoursPerDay': hoursPerDay,
      'hoursSpent': hoursSpent,
    };
  }

  factory TailorItem.fromJson(Map<String, dynamic> json) {
    return TailorItem(
      name: json['name'] ?? '',
      salaryPerMonth: (json['salaryPerMonth'] as num).toDouble(),
      daysPerMonth: (json['daysPerMonth'] as num).toDouble(),
      hoursPerDay: (json['hoursPerDay'] as num).toDouble(),
      hoursSpent: (json['hoursSpent'] as num).toDouble(),
    );
  }
}

class NewCalcPage extends StatefulWidget {
	const NewCalcPage({super.key, this.initialInput});

  final Map<String, dynamic>? initialInput;

	@override
	State<NewCalcPage> createState() => _NewCalcPageState();
}

class _NewCalcPageState extends State<NewCalcPage> {

  final _calcformkey = GlobalKey<FormState>();
  late Map<String, dynamic> input;
  List<MaterialItem> materials = [];
  List<TransportItem> transports = [];
  List<OverheadItem> overheads = [];
  List<TailorItem> tailors = [];

  @override
  void initState() {
    super.initState();
    
    // Initialize input with template data or defaults
    input = widget.initialInput ?? {
      'outfitName': '',
      'category': '',
      'profitMarginPct': 0,
    };
    
    // If initialInput contains comprehensive template data, load it
    _loadTemplateData();
  }
  
  void _loadTemplateData() {
    if (widget.initialInput == null) return;

    final initialInput = widget.initialInput!;

    // Update all data at once to ensure UI refresh
    setState(() {
      this.materials = initialInput['materials'];
      this.transports = initialInput['transports'];
      this.overheads = initialInput['overheads'];
      this.tailors = initialInput['tailors'];
    });
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
              Text(
                'Job Details:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
              _buildMaterialsList(),
              SizedBox(height: 12),
              _buildAddingMaterialsButton(),
              SizedBox(height: 12),
              _buildTransportList(),
              SizedBox(height: 12),
              _buildAddingTransportButton(),
              SizedBox(height: 12),
              _buildOverheadsList(),
              SizedBox(height: 12),
              _buildAddingOverheadButton(),
              SizedBox(height: 12),
              _buildTailorList(),
              SizedBox(height: 12),
              _buildAddingTailorButton(),
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

  Widget _buildProfitMarginField() { // Profit Margin Field with default hint
    final defaultMargin = SettingsHelper.getDefaultMargin();
    final initialValue = input['profitMarginPct'] ?? SettingsHelper.getDefaultMargin();
    return TextFormField(
      initialValue: initialValue > 0 ? initialValue.toString() : defaultMargin.toString(),
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
          input['profitMarginPct'] = double.tryParse(newValue) ?? SettingsHelper.getDefaultMargin();
        } else {
          input['profitMarginPct'] = SettingsHelper.getDefaultMargin(); // Will use default in calculation
        }
      }
    );
  }

  Widget _buildAddingMaterialsButton() {
    return MaterialButton(
      color: Colors.green,
      textColor: Colors.white,
      minWidth: 120,
      height: 40,
      onPressed: _showAddMaterialDialog,
      child: Text('Add Material')
    );
  }

  Widget _buildAddingTransportButton() {
    return MaterialButton(
      color: Colors.green,
      textColor: Colors.white,
      minWidth: 120,
      height: 40,
      onPressed: _showAddTransportDialog,
      child: Text('Add Transport')
    );
  }

  Widget _buildAddingOverheadButton() {
    return MaterialButton(
      color: Colors.green,
      textColor: Colors.white,
      minWidth: 120,
      height: 40,
      onPressed: _showAddOverheadDialog,
      child: Text('Add Overhead')
    );
  }

  Widget _buildAddingTailorButton() {
    return MaterialButton(
      color: Colors.green,
      textColor: Colors.white,
      minWidth: 120,
      height: 40,
      onPressed: _showAddTailorDialog,
      child: Text('Add Labor')
    );
  }

  Widget _buildMaterialsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Materials:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        if (materials.isNotEmpty)
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: materials.asMap().entries.map((entry) {
              int index = entry.key;
              MaterialItem material = entry.value;
              return ListTile(
                title: Text(material.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(material.length.toStringAsFixed(0))
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(material.cost.toStringAsFixed(2))
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editMaterial(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeItem(materials, index),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Total Materials Cost: ${_getMaterialsTotal().toStringAsFixed(2)}',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ],
    );
  }

  Widget _buildOverheadsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overheads:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        if (overheads.isNotEmpty)
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: overheads.asMap().entries.map((entry) {
              int index = entry.key;
              OverheadItem overhead = entry.value;
              return ListTile(
                title: Text(overhead.type),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(overhead.hours.toStringAsFixed(2))
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(overhead.cost.toStringAsFixed(2))
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editOverhead(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeItem(overheads, index),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Total Overhead Cost: ${_getOverheadsTotal().toStringAsFixed(2)}',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ],
    );
  }

  Widget _buildTransportList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transport:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        if (transports.isNotEmpty)
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: transports.asMap().entries.map((entry) {
              int index = entry.key;
              TransportItem transport = entry.value;
              return ListTile(
                title: Text(transport.location),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Text(transport.cost.toStringAsFixed(2))
                    ),
                    // Padding(
                    //   padding: EdgeInsetsGeometry.only(left: 30.0),
                    //   child: Text(transport.notes)
                    // ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editTransport(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeItem(transports, index),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Total Transports Cost: ${_getTransportsTotal().toStringAsFixed(2)}',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ],
    );
  }

  Widget _buildTailorList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Labor:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        if (tailors.isNotEmpty)
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: tailors.asMap().entries.map((entry) {
              int index = entry.key;
              TailorItem labor = entry.value;
              return ListTile(
                title: Text(labor.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(labor.salaryPerMonth.toStringAsFixed(2))
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(labor.daysPerMonth.toStringAsFixed(0))
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(labor.hoursPerDay.toStringAsFixed(2))
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(labor.hoursSpent.toStringAsFixed(2))
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editLabor(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeItem(tailors, index),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Total Labor Cost: ${_getLaborTotal().toStringAsFixed(2)}',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ],
    );
  }

  Widget _buildCalculateButton() {
    return MaterialButton(
      color: Colors.blue,
      textColor: Colors.white,
      minWidth: 100,
      height: 50,
      onPressed: () {
        if (_calcformkey.currentState!.validate()) {
          final result = _calculate();
          final allInputData = {
            ...input,
            'materials': materials,
            'transports': transports,
            'overheads': overheads,
            'tailors': tailors,
          };
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return ResultPage(
                  result: result,
                  input: allInputData
                );
              }
            )
          );
        }
      },
      child: Text('Calculate Price')
    );
  }
  
  Map<String, dynamic> _calculate() {
    // Add materials total
    double materialsTotal = _getMaterialsTotal();
    double transportTotal = _getTransportsTotal();
    double overheadTotal = _getOverheadsTotal();
    double laborTotal = _getLaborTotal();
    
    // Use profit margin from input if provided, otherwise use default from settings
    double profitMarginPct = (input['profitMarginPct'] != null && (input['profitMarginPct'] as num) > 0)
        ? (input['profitMarginPct'] as num).toDouble()
        : SettingsHelper.getDefaultMargin();

    double costTotal = materialsTotal + laborTotal + overheadTotal + transportTotal;
    double profitAmount = costTotal * (profitMarginPct / 100);
    double sellingPrice = costTotal + profitAmount;

    return {
      'materialsTotal': materialsTotal,
      'laborTotal': laborTotal,
      'overheadTotal': overheadTotal,
      'transportTotal': transportTotal,
      'costTotal': costTotal,
      'sellingPrice': sellingPrice,
      'profitAmount': profitAmount,
      'profitMarginPct': profitMarginPct,
    };
  }

  void _showAddMaterialDialog() {
    final materialNameController = TextEditingController();
    final materialLengthController = TextEditingController();
    final materialCostController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Material'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: materialNameController,
                decoration: InputDecoration(
                  labelText: 'Material Type',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: materialLengthController,
                decoration: InputDecoration(
                  labelText: 'Material Length',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: materialCostController,
                decoration: InputDecoration(
                  labelText: 'Cost per Unit',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = materialNameController.text.trim();
                final length = double.tryParse(materialLengthController.text);
                final cost = double.tryParse(materialCostController.text);
                
                if (name.isNotEmpty && cost != null && cost >= 0 && length != null && length >= 0) {
                  setState(() {
                    materials.add(MaterialItem(name: name, length: length, cost: cost));
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter valid input'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );  
  }

  void _showAddTransportDialog() {
    final transportLocationController = TextEditingController();
    final transportCostController = TextEditingController();
    final transportNotesController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Transport'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: transportLocationController,
                decoration: InputDecoration(
                  labelText: 'Market Location',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: transportCostController,
                decoration: InputDecoration(
                  labelText: 'Transport Cost',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: transportNotesController,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final location = transportLocationController.text.trim();
                final notes = transportNotesController.text.trim();
                final cost = double.tryParse(transportCostController.text);
                
                if (location.isNotEmpty && cost != null && cost >= 0) {
                  setState(() {
                    transports.add(TransportItem(location: location, cost: cost, notes: notes));
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter valid input'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddOverheadDialog() {
    final overheadTypeController = TextEditingController();
    final overheadHourController = TextEditingController();
    final overheadCostController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Overhead'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: overheadTypeController,
                decoration: InputDecoration(
                  labelText: 'Type of Overhead',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: overheadHourController,
                decoration: InputDecoration(
                  labelText: 'Hours Used',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: overheadCostController,
                decoration: InputDecoration(
                  labelText: 'Cost per Hour',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final type = overheadTypeController.text.trim();
                final hours = double.tryParse(overheadHourController.text);
                final cost = double.tryParse(overheadCostController.text);
                
                if (type.isNotEmpty && cost != null && cost >= 0 && hours != null && hours >= 0) {
                  setState(() {
                    overheads.add(OverheadItem(type: type, cost: cost, hours: hours));
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter valid input'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddTailorDialog() {
    final tailorNameController = TextEditingController();
    final tailorMonthlySalaryController = TextEditingController();
    final tailorDaysPerMonthController = TextEditingController();
    final tailorHoursPerDayController = TextEditingController();
    final tailorHoursSpentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Labor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tailorNameController,
                decoration: InputDecoration(
                  labelText: 'Tailor Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: tailorMonthlySalaryController,
                decoration: InputDecoration(
                  labelText: 'Monthly Salary',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: tailorDaysPerMonthController,
                decoration: InputDecoration(
                  labelText: 'Days Per Month',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: tailorHoursPerDayController,
                decoration: InputDecoration(
                  labelText: 'Hours Per Day',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: tailorHoursSpentController,
                decoration: InputDecoration(
                  labelText: 'Hours Spent',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = tailorNameController.text.trim();
                final salary = double.tryParse(tailorMonthlySalaryController.text);
                final days = double.tryParse(tailorDaysPerMonthController.text);
                final hoursPerDay = double.tryParse(tailorHoursPerDayController.text);
                final hours = double.tryParse(tailorHoursSpentController.text);
                
                if (name.isNotEmpty && salary != null && salary >= 0  && days != null && days >= 0  && hoursPerDay != null && hoursPerDay >= 0  && hours != null && hours >= 0) {
                  setState(() {
                    tailors.add(TailorItem(name: name, salaryPerMonth: salary, daysPerMonth: days, hoursPerDay: hoursPerDay, hoursSpent: hours));
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter valid input'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeItem(List list, int index) {
    setState(() {
      list.removeAt(index);
    });
  }

  void _editMaterial(int index) {
    final material = materials[index];
    final materialNameController = TextEditingController(text: material.name);
    final materialLengthController = TextEditingController(text: material.length.toString());
    final materialCostController = TextEditingController(text: material.cost.toString());
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Material'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: materialNameController,
                decoration: InputDecoration(
                  labelText: 'Material Type',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: materialLengthController,
                decoration: InputDecoration(
                  labelText: 'Material Length',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: materialCostController,
                decoration: InputDecoration(
                  labelText: 'Cost per Unit',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = materialNameController.text.trim();
                final length = double.tryParse(materialLengthController.text);
                final cost = double.tryParse(materialCostController.text);
                
                if (name.isNotEmpty && cost != null && cost >= 0 && length != null && length >= 0) {
                  setState(() {
                    materials[index] = MaterialItem(name: name, length: length, cost: cost);
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter valid input'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _editTransport(int index) {
    final transport = transports[index];
    final transportLocationController = TextEditingController(text: transport.location);
    final transportCostController = TextEditingController(text: transport.cost.toString());
    final transportNotesController = TextEditingController(text: transport.notes);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Transport'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: transportLocationController,
                decoration: InputDecoration(
                  labelText: 'Market Location',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: transportCostController,
                decoration: InputDecoration(
                  labelText: 'Transport Cost',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: transportNotesController,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final location = transportLocationController.text.trim();
                final notes = transportNotesController.text.trim();
                final cost = double.tryParse(transportCostController.text);
                
                if (location.isNotEmpty && cost != null && cost >= 0) {
                  setState(() {
                    transports[index] = TransportItem(location: location, cost: cost, notes: notes);
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter valid input'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _editOverhead(int index) {
    final overhead = overheads[index];
    final overheadTypeController = TextEditingController(text: overhead.type);
    final overheadHourController = TextEditingController(text: overhead.hours.toString());
    final overheadCostController = TextEditingController(text: overhead.cost.toString());
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Overhead'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: overheadTypeController,
                decoration: InputDecoration(
                  labelText: 'Type of Overhead',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: overheadHourController,
                decoration: InputDecoration(
                  labelText: 'Hours Used',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: overheadCostController,
                decoration: InputDecoration(
                  labelText: 'Cost per Hour',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final type = overheadTypeController.text.trim();
                final hours = double.tryParse(overheadHourController.text);
                final cost = double.tryParse(overheadCostController.text);
                
                if (type.isNotEmpty && cost != null && cost >= 0 && hours != null && hours >= 0) {
                  setState(() {
                    overheads[index] = OverheadItem(type: type, cost: cost, hours: hours);
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter valid input'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _editLabor(int index) {
    final labor = tailors[index];
    final tailorNameController = TextEditingController(text: labor.name);
    final tailorMonthlySalaryController = TextEditingController(text: labor.salaryPerMonth.toString());
    final tailorDaysPerMonthController = TextEditingController(text: labor.daysPerMonth.toString());
    final tailorHoursPerDayController = TextEditingController(text: labor.hoursPerDay.toString());
    final tailorHoursSpentController = TextEditingController(text: labor.hoursSpent.toString());
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Labor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tailorNameController,
                decoration: InputDecoration(
                  labelText: 'Tailor Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: tailorMonthlySalaryController,
                decoration: InputDecoration(
                  labelText: 'Monthly Salary',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: tailorDaysPerMonthController,
                decoration: InputDecoration(
                  labelText: 'Days Per Month',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: tailorHoursPerDayController,
                decoration: InputDecoration(
                  labelText: 'Hours Per Day',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: tailorHoursSpentController,
                decoration: InputDecoration(
                  labelText: 'Hours Spent',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = tailorNameController.text.trim();
                final salary = double.tryParse(tailorMonthlySalaryController.text);
                final days = double.tryParse(tailorDaysPerMonthController.text);
                final hoursPerDay = double.tryParse(tailorHoursPerDayController.text);
                final hours = double.tryParse(tailorHoursSpentController.text);
                
                if (name.isNotEmpty && salary != null && salary >= 0  && days != null && days >= 0  && hoursPerDay != null && hoursPerDay >= 0  && hours != null && hours >= 0) {
                  setState(() {
                    tailors[index] = TailorItem(name: name, salaryPerMonth: salary, daysPerMonth: days, hoursPerDay: hoursPerDay, hoursSpent: hours);
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter valid input'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  double _getMaterialsTotal() {
    return materials.fold(0.0, (sum, material) => sum + material.cost * material.length);
  }

  double _getTransportsTotal() {
    return transports.fold(0.0, (sum, transport) => sum + transport.cost);
  }

  double _getOverheadsTotal() {
    return overheads.fold(0.0, (sum, overhead) => sum + overhead.cost * overhead.hours);
  }

  double _getLaborTotal() {
    return tailors.fold(0.0, (sum, tailor) => sum + tailor.salaryPerMonth / (tailor.daysPerMonth * tailor.hoursPerDay) * tailor.hoursSpent);
  }
}