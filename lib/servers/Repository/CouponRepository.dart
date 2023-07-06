import 'package:dio/dio.dart';
import 'package:lazyload/servers/Repository/FoodRepository.dart';

import '../../helpers/constans.dart';

class CouponRepository {
  final Dio _dio = Dio();
  Future<List<CouponFoodList>> getListCoupon() async {
    try {
      final response = await _dio.get(ApiLink.apiAddres + "Coupons");
final List couponList = response.data;
final List<Coupon> coupons = couponList.map((e) => Coupon.fromJson(e)).toList();

final response2 = await _dio.get(ApiLink.apiAddres + "CouponFoods");
final List couponFoodsList = response2.data;
final List<CouponFoods> couponFoods = couponFoodsList.map((e) => CouponFoods.fromJson(e)).toList();

final response3 = await _dio.get(ApiLink.apiAddres + "Foods");
final List foodList = response3.data;
List<CouponFoodList> foodCoupon = [];

// Группировка купонов по couponId
Map<int, List<CouponFoods>> groupedCouponFoods = {};
for (CouponFoods couponFood in couponFoods) {
  if (groupedCouponFoods.containsKey(couponFood.couponId)) {
    groupedCouponFoods[couponFood.couponId]!.add(couponFood);
  } else {
    groupedCouponFoods[couponFood.couponId] = [couponFood];
  }
}

// Обработка купонов и их еды
for (Coupon coupon in coupons) {
  if (groupedCouponFoods.containsKey(coupon.couponID)) {
    List<CouponFoods> foods = groupedCouponFoods[coupon.couponID]!;
    List<FoodCoupon> couponFoods = [];

    for (CouponFoods couponFood in foods) {
      Food food = Food.fromJson(foodList.where((element) => element["idFood"] == couponFood.foodId).first);
      FoodCoupon foodCoupon = new FoodCoupon(couponFood.count, nameFood: food.nameFood, descriptionFood: food.descriptionFood, ingredientsFood: food.ingredientsFood, imageFood: food.imageFood, priceFood: food.priceFood, salePriceFood: food.salePriceFood, sizeFood: food.sizeFood, weightFood: food.weightFood, calFood: food.calFood, categoryId: food.categoryId, carbohydrates: food.carbohydrates, proteins: food.proteins, fats: food.fats);
      couponFoods.add(foodCoupon);
    }

    foodCoupon.add(CouponFoodList(
      coupon.couponNumber,
      coupon.imageLink,
      coupon.priceCoupone,
      coupon.salePriceCoupone,
      couponFoods,
    ));
  }
}

return foodCoupon;

      // final response = await _dio.get(ApiLink.apiAddres + "Coupons");
      // final List couponlist = response.data;
      // final List<Coupon> list = couponlist.map((e) => Coupon.fromJson(e)).toList();
      // final response2 = await _dio.get(ApiLink.apiAddres + "CouponFoods");
      // final List couponlist2 = response2.data;
      // final List<CouponFoods> list2 = couponlist2.map((e) => CouponFoods.fromJson(e)).toList();
      //  final response3 = await _dio.get(ApiLink.apiAddres + "Foods");
      // final List couponlist3 = response3.data;
      // List<Food> foodList;
      // List<CouponFoodList> FoodCoupon = [];
      // list2.forEach((element) {
      //   Coupon coupon = list.where((element2) => element2.couponID == element.couponId).first;
      //   Food food = Food.fromJson(couponlist3.where((element3) => (element3["idFood"] as int) == element.foodId).first);
      //   FoodCoupon.add(CouponFoodList(coupon.couponNumber, coupon.imageLink, coupon.priceCoupone, coupon.salePriceCoupone, food, element.count));
      //  });
      // return FoodCoupon;
    } catch (e) {
      throw Exception(e);
    }
  }
}

class FoodCoupon extends Food{
  final int count;

  FoodCoupon(this.count, {required super.nameFood, required super.descriptionFood, required super.ingredientsFood, required super.imageFood, required super.priceFood, required super.salePriceFood, required super.sizeFood, required super.weightFood, required super.calFood, required super.categoryId, required super.carbohydrates, required super.proteins, required super.fats});

}

class CouponFoodList{
  final String couponNumber;
  final String imageLink;
  final int priceCoupone;
  final int salePriceCoupone;
  final List<FoodCoupon> food;

  CouponFoodList(this.couponNumber, this.imageLink, this.priceCoupone, this.salePriceCoupone, this.food);
}

class Coupon {
  final int couponID;
  final String couponNumber;
  final String imageLink;
  final int priceCoupone;
  final int salePriceCoupone;

  Coupon(
    this.couponID,
      this.couponNumber,
      this.imageLink,
      this.priceCoupone,
      this.salePriceCoupone);
  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      json["couponId"],
        json['couponName'],
        json['couponImageLink'],
        json['price'],
        json['discountPrice'],
        );
  }
}

class CouponFoods {
  final int couponFoodsID;
  final int count;
  final int foodId;
  final int couponId;

  
  factory CouponFoods.fromJson(Map<String, dynamic> json) {
    return CouponFoods(
      json["couponFoodId"],
        json['countFood'],
        json['foodId'],
        json['couponId'],
        );
  }

  CouponFoods(this.couponFoodsID, this.count, this.foodId, this.couponId);
}
