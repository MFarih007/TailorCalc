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
      computed: Computed.fromJson(json['computed'])
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
  final double fabric;
  final double lining;
  final double accessories;
  final double laborHours;
  final double laborRate;
  final double transportMisc;
  final double overhead;
  final double profitMarginPct;

  Inputs({
    required this.fabric,
    required this.lining,
    required this.accessories,
    required this.laborHours,
    required this.laborRate,
    required this.transportMisc,
    required this.overhead,
    required this.profitMarginPct,
  });

  factory Inputs.fromJson(Map<String, dynamic> json) {
    return Inputs(
      fabric: (json['fabric'] as num).toDouble(),
      lining: (json['lining'] as num).toDouble(),
      accessories: (json['accessories'] as num).toDouble(),
      laborHours: (json['laborHours'] as num).toDouble(),
      laborRate: (json['laborRate'] as num).toDouble(),
      transportMisc: (json['transportMisc'] as num).toDouble(),
      overhead: (json['overhead'] as num).toDouble(),
      profitMarginPct: (json['profitMarginPct'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fabric': fabric,
      'lining': lining,
      'accessories': accessories,
      'laborHours': laborHours,
      'laborRate': laborRate,
      'transportMisc': transportMisc,
      'overhead': overhead,
      'profitMarginPct': profitMarginPct,
    };
  }
}

class Computed {
  final double materialsTotal;
  final double laborTotal;
  final double overheadTotal;
  final double costTotal;
  final double profitAmount;
  final double sellingPrice;

  Computed({
    required this.materialsTotal,
    required this.laborTotal,
    required this.overheadTotal,
    required this.costTotal,
    required this.profitAmount,
    required this.sellingPrice
  });

  factory Computed.fromJson(Map<String, dynamic> json) {
    return Computed(
      materialsTotal: (json['materialsTotal'] as num).toDouble(),
      laborTotal: (json['laborTotal'] as num).toDouble(),
      overheadTotal: (json['overheadTotal'] as num).toDouble(),
      costTotal: (json['costTotal'] as num).toDouble(),
      profitAmount: (json['profitAmount'] as num).toDouble(),
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'materialsTotal': materialsTotal,
      'laborTotal': laborTotal,
      'overheadTotal': overheadTotal,
      'costTotal': costTotal,
      'profitAmount': profitAmount,
      'sellingPrice': sellingPrice,
    };
  }
}