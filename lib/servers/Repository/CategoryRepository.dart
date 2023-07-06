import 'package:dio/dio.dart';

import '../../helpers/constans.dart';

class CategoryRepository {
  final Dio _dio = Dio();

  Future<List<Category>>  getCategoryList() async {
    try {
      final response =
          await _dio.get(ApiLink.apiAddres+"categories");
      final List categorylist = response.data;
      return categorylist.map((e) => Category.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}

class Category {
  final int idCategory;
  final String nameCategory;
  final String? imageCategory;
  Category(
      {required this.idCategory,
        required this.nameCategory,
      required this.imageCategory,
});
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      idCategory: json['idCategory'],
      nameCategory: json['nameCategory'],
      imageCategory: json['imageCategory'],
    );
  }
}
