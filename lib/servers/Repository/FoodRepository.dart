import 'package:dio/dio.dart';

import '../../helpers/constans.dart';

class FoodRepository {
  final Dio _dio = Dio();

  Future<List<Food>> getFoodList() async {
    try {     
      final response = await _dio.get(ApiLink.apiAddres + "foods");
      final List foodlist = response.data;
      return foodlist.map((e) => Food.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e);
    } 
  }
}

class Food {
  final String nameFood;
  final String descriptionFood;
  final String ingredientsFood;
  final String? imageFood;
  final int priceFood;
  final int? salePriceFood;
  final int? sizeFood;
  final int weightFood;
  final int calFood;
  final int categoryId;
  final double? carbohydrates;
  final double? proteins;
  final double? fats;

  Food({
    required this.nameFood,
    required this.descriptionFood,
    required this.ingredientsFood,
    required this.imageFood,
    required this.priceFood,
    required this.salePriceFood,
    required this.sizeFood,
    required this.weightFood,
    required this.calFood,
    required this.categoryId,
    required this.carbohydrates,
    required this.proteins,
    required this.fats,
  });

 factory Food.fromJson(Map<String, dynamic> json) {
  return Food(
    nameFood: json['nameFood'] as String,
    descriptionFood: json['descriptionFood'] as String,
    ingredientsFood: json['ingredientsFood'] as String,
    imageFood: json['imageFood'] as String?,
    priceFood: json['priceFood'] as int,
    salePriceFood: json['salePriceFood'] as int?,
    sizeFood: json['sizeFood'] as int?,
    weightFood: json['weightFood'] as int,
    calFood: json['calFood'] as int,
    categoryId: json['categoryId'] as int,
    carbohydrates: json['carbohydrates']?.toDouble(),
    proteins: json['proteins']?.toDouble(),
    fats: json['fats']?.toDouble(),
  );
}

}
