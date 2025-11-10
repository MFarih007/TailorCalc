import 'package:tailor_calc/models/pricinghistoryrecord.dart';

class Template {
  int? id;
  String templateName;
  String outfitName;
  String category;
  String currency;
  Inputs inputs;
  DateTime createdAt;
  DateTime updatedAt;

  Template({
    this.id,
    required this.templateName,
    required this.outfitName,
    required this.category,
    required this.currency,
    required this.inputs,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Template.fromJson(Map<String, dynamic> json) {
    // Parse materials, transports, overheads, and tailors if present
    return Template(
      id: json['id'],
      templateName: json['templateName'] ?? '',
      outfitName: json['outfitName'] ?? '',
      category: json['category'] ?? '',
      currency: json['currency'] ?? '',
      inputs: Inputs.fromJson(json['inputs']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'templateName': templateName,
      'outfitName': outfitName,
      'category': category,
      'currency': currency,
      'inputs': inputs.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Convert to input map for use in new calculation
  Map<String, dynamic> toInputMap() {
    return {
      'outfitName': outfitName,
      'category': category,
      'currency': currency,
      'materials': inputs.materials,
      'transports': inputs.transports,
      'overheads': inputs.overheads,
      'tailors': inputs.labors,
      'profitMarginPct': inputs.profitMarginPct,
    };
  }
}

