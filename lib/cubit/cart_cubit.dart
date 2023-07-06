import 'package:bloc/bloc.dart';
import 'package:lazyload/servers/Repository/CartRepository.dart';
import 'package:lazyload/servers/Repository/CouponRepository.dart';
import 'package:lazyload/servers/Repository/Presenter/CartPresenter.dart';
import 'package:lazyload/servers/Repository/UserRepository.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../servers/Repository/FoodRepository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitialState());
  String time = "";
  bool packet = false;
  bool paymentCard = true;
  bool paymentCardSave = true;

  Future<void> setCartList(Food food, bool isCoupon, [CouponFoodList? couponFoodList]) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartList =[];
    if (isCoupon) {
      cartList = [
        couponFoodList!.couponNumber,
        couponFoodList!.salePriceCoupone.toString(),
        couponFoodList.imageLink.toString()
      ];
    } else {
       cartList = [
        food.nameFood,
        food.priceFood.toString(),
        food.imageFood.toString()
      ];
    }

    final CartPresenter cartPresenter =
        await CartPresenter(CartRepository(prefs));
    int count = 0;
    List<String> list = await cartPresenter.getCartList();
    if (list.isEmpty) {
      count++;
    } else {
      list.forEach((element) {
        List<String> list3 =
            element.substring(1, element.length - 1).split(", ");
        if (list3[0] == cartList[0]) {
          count = int.parse(list3[3]);
          count++;
        }
      });
    }
    if (count == 0) {
      count++;
    }
    cartList.add(count.toString());
    await cartPresenter.setCartList(cartList);
  }

  Future<void> removeCartList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final CartPresenter cartPresenter =
        await CartPresenter(CartRepository(prefs));
    await cartPresenter.removeCartList();
  }

  Future<void> removeCart(Food food, bool isCoupon, [CouponFoodList? couponFoodList]) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> cartList =[];
    if (isCoupon) {
      cartList = [
        couponFoodList!.couponNumber,
        couponFoodList!.salePriceCoupone.toString(),
        couponFoodList.imageLink.toString()
      ];
    } else {
       cartList = [
        food.nameFood,
        food.priceFood.toString(),
        food.imageFood.toString()
      ];
    }
    final CartPresenter cartPresenter =
        await CartPresenter(CartRepository(prefs));
    await cartPresenter.removeCartItem(cartList);
  }

  Future<void> getCartList() async {
    emit(CartLoadingState());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final CartPresenter cartPresenter =
        await CartPresenter(CartRepository(prefs));
    List<String> list = cartPresenter.getCartList();
    List<String> list2 = [];
    list.forEach((element) {
      String str = element;
      List<String> list3 = str.substring(1, str.length - 1).split(", ");
      list2.add(list3.toString());
    });
    List<String> list4 = list2.toSet().toList();
    list4.sort();

    print(list4);
    List<String> listRestaraunt = await cartPresenter.getRestaraunt();
    emit(CartLoadedState(list4, listRestaraunt[0], listRestaraunt[1]));
  }
}
