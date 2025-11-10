import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tailor_calc/pages/newcalc.dart';

class PricingHistoryRecord {
  int? id;
  String historyId;
  DateTime createdAt;
  String outfitName;
  String category;
  String currency;
  Inputs inputs;
  Computed computed;

  PricingHistoryRecord({
    this.id,
    required this.historyId,
    required this.createdAt,
    required this.outfitName,
    required this.category,
    required this.currency,
    required this.inputs,
    required this.computed
  });

  factory PricingHistoryRecord.fromJson(Map<String, dynamic> json) {
    return PricingHistoryRecord(
      id: json['id'],
      historyId: json['historyId'],
      createdAt: DateTime.parse(json['createdAt']),
      outfitName: json['outfitName'],
      category: json['category'],
      currency: json['currency'],
      inputs: Inputs.fromJson(json['inputs']),
      computed: Computed.fromJson(json['computed'] ?? json['outputs']) // Support both field names
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'historyId': historyId,
      'createdAt': createdAt.toIso8601String(),
      'outfitName': outfitName,
      'category': category,
      'currency': currency,
      'inputs': inputs.toJson(),
      'computed': computed.toJson(),
    };
  }
}

class Inputs {
  final List<TailorItem> labors;
  final List<MaterialItem> materials;
  final List<TransportItem> transports;
  final List<OverheadItem> overheads;
  final double profitMarginPct;

  Inputs({
    required this.labors,
    required this.materials,
    required this.transports,
    required this.overheads,
    required this.profitMarginPct
  });

  factory Inputs.fromJson(Map<String, dynamic> json) {
    // Parse lists of maps to custom objects
    final laborsList = (json['labors'] as List?)?.map((item) {
      if (item is Map<String, dynamic>) {
        return TailorItem.fromJson(item);
      }
      return null;
    }).where((item) => item != null).cast<TailorItem>().toList() ?? [];
    
    final materialsList = (json['materials'] as List?)?.map((item) {
      if (item is Map<String, dynamic>) {
        return MaterialItem.fromJson(item);
      }
      return null;
    }).where((item) => item != null).cast<MaterialItem>().toList() ?? [];
    
    final transportsList = (json['transports'] as List?)?.map((item) {
      if (item is Map<String, dynamic>) {
        return TransportItem.fromJson(item);
      }
      return null;
    }).where((item) => item != null).cast<TransportItem>().toList() ?? [];
    
    final overheadsList = (json['overheads'] as List?)?.map((item) {
      if (item is Map<String, dynamic>) {
        return OverheadItem.fromJson(item);
      }
      return null;
    }).where((item) => item != null).cast<OverheadItem>().toList() ?? [];
    
    return Inputs(
      labors: laborsList,
      materials: materialsList,
      transports: transportsList,
      overheads: overheadsList,
      profitMarginPct: (json['profitMarginPct'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'labors': labors.map((item) => item.toJson()).toList(),
      'materials': materials.map((item) => item.toJson()).toList(),
      'transports': transports.map((item) => item.toJson()).toList(),
      'overheads': overheads.map((item) => item.toJson()).toList(),
      'profitMarginPct': profitMarginPct,
    };
  }
}

class Computed {
  final double laborTotal;
  final double materialsTotal;
  final double transportTotal;
  final double overheadTotal;
  final double costTotal;
  final double profitAmount;
  final double sellingPrice;

  Computed({
    required this.laborTotal,
    required this.materialsTotal,
    required this.transportTotal,
    required this.overheadTotal,
    required this.costTotal,
    required this.profitAmount,
    required this.sellingPrice
  });

  factory Computed.fromJson(Map<String, dynamic> json) {
    return Computed(
      laborTotal: (json['laborTotal'] as num?)?.toDouble() ?? 0.0,
      materialsTotal: (json['materialsTotal'] as num?)?.toDouble() ?? 0.0,
      transportTotal: (json['transportTotal'] as num?)?.toDouble() ?? 0.0,
      overheadTotal: (json['overheadTotal'] as num?)?.toDouble() ?? 0.0,
      costTotal: (json['costTotal'] as num?)?.toDouble() ?? 0.0,
      profitAmount: (json['profitAmount'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'laborTotal': laborTotal,
      'materialsTotal': materialsTotal,
      'transportTotal': transportTotal,
      'overheadTotal': overheadTotal,
      'costTotal': costTotal,
      'profitAmount': profitAmount,
      'sellingPrice': sellingPrice,
    };
  }
}