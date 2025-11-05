class Template {
  int? id;
  String templateName;
  String outfitName;
  String category;
  double fabric;
  double lining;
  double accessories;
  double laborHours;
  double laborRate;
  double transportMisc;
  double overhead;
  double profitMarginPct;
  DateTime createdAt;
  DateTime updatedAt;

  Template({
    this.id,
    required this.templateName,
    required this.outfitName,
    required this.category,
    required this.fabric,
    required this.lining,
    required this.accessories,
    required this.laborHours,
    required this.laborRate,
    required this.transportMisc,
    required this.overhead,
    required this.profitMarginPct,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json['id'],
      templateName: json['templateName'],
      outfitName: json['outfitName'],
      category: json['category'],
      fabric: (json['fabric'] as num).toDouble(),
      lining: (json['lining'] as num).toDouble(),
      accessories: (json['accessories'] as num).toDouble(),
      laborHours: (json['laborHours'] as num).toDouble(),
      laborRate: (json['laborRate'] as num).toDouble(),
      transportMisc: (json['transportMisc'] as num).toDouble(),
      overhead: (json['overhead'] as num).toDouble(),
      profitMarginPct: (json['profitMarginPct'] as num).toDouble(),
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
      'fabric': fabric,
      'lining': lining,
      'accessories': accessories,
      'laborHours': laborHours,
      'laborRate': laborRate,
      'transportMisc': transportMisc,
      'overhead': overhead,
      'profitMarginPct': profitMarginPct,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Convert to input map for use in new calculation
  Map<String, dynamic> toInputMap() {
    return {
      'outfitName': outfitName,
      'category': category,
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

