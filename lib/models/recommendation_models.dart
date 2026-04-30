class CropRecommendation {
  final String id;
  final String fieldId;
  final List<RecommendedCrop> crops;
  final String? season;
  final DateTime generatedAt;

  CropRecommendation({
    required this.id,
    required this.fieldId,
    required this.crops,
    this.season,
    required this.generatedAt,
  });

  factory CropRecommendation.fromJson(Map<String, dynamic> json) {
    var cropsList = json['recommended_crops'] as List;
    return CropRecommendation(
      id: json['id'],
      fieldId: json['field_id'],
      crops: cropsList.map((i) => RecommendedCrop.fromJson(i)).toList(),
      season: json['season'],
      generatedAt: DateTime.parse(json['generated_at']),
    );
  }
}

class RecommendedCrop {
  final int rank;
  final String name;
  final double confidenceScore;
  final String? sowingMonth;
  final String? harvestMonth;

  RecommendedCrop({
    required this.rank,
    required this.name,
    required this.confidenceScore,
    this.sowingMonth,
    this.harvestMonth,
  });

  factory RecommendedCrop.fromJson(Map<String, dynamic> json) {
    return RecommendedCrop(
      rank: json['rank'],
      name: json['crop_name'],
      confidenceScore: json['confidence_score'].toDouble(),
      sowingMonth: json['sowing_month'],
      harvestMonth: json['harvest_month'],
    );
  }
}
