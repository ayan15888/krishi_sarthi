class Field {
  final String id;
  final String farmerId;
  final String name;
  final double areaBigha;
  final String? soilType;
  final String? waterSource;
  final bool isIrrigated;

  Field({
    required this.id,
    required this.farmerId,
    required this.name,
    required this.areaBigha,
    this.soilType,
    this.waterSource,
    this.isIrrigated = false,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'],
      farmerId: json['farmer_id'],
      name: json['name'],
      areaBigha: json['area_bigha'].toDouble(),
      soilType: json['soil_type'],
      waterSource: json['water_source'],
      isIrrigated: json['is_irrigated'] ?? false,
    );
  }
}

class SoilRecord {
  final String id;
  final String fieldId;
  final double? nitrogen;
  final double? phosphorus;
  final double? potassium;
  final double? phLevel;
  final String? season;
  final DateTime sampleDate;

  SoilRecord({
    required this.id,
    required this.fieldId,
    this.nitrogen,
    this.phosphorus,
    this.potassium,
    this.phLevel,
    this.season,
    required this.sampleDate,
  });

  factory SoilRecord.fromJson(Map<String, dynamic> json) {
    return SoilRecord(
      id: json['id'],
      fieldId: json['field_id'],
      nitrogen: json['nitrogen_kg_ha']?.toDouble(),
      phosphorus: json['phosphorus_kg_ha']?.toDouble(),
      potassium: json['potassium_kg_ha']?.toDouble(),
      phLevel: json['ph_level']?.toDouble(),
      season: json['season'],
      sampleDate: DateTime.parse(json['sample_date']),
    );
  }
}
