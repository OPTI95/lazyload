import 'package:shared_preferences/shared_preferences.dart';

class CartRepository {
  final SharedPreferences sharedPreferences;

  CartRepository(this.sharedPreferences);
  List<String> getCartList() {
    try {
      return sharedPreferences.getStringList("Cart") ?? [];
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> saveRestaraunt(String nameRestaraunt) async {
    return await sharedPreferences.setString("Restatunt", nameRestaraunt);
  }

  Future<bool> saveAddressRestaraunt(String addressRestaraunt) async {
    return await sharedPreferences.setString(
        "AddressRestatunt", addressRestaraunt);
  }

  List<String> getRestaraut() {
    List<String> list = [
      sharedPreferences.getString("Restatunt") ?? "",
      sharedPreferences.getString("AddressRestatunt") ?? ""
    ];
    return list;
  }

  Future<void> setCartList(List<String> cart) async {
    try {
      final cartItems = getCartList();
      try {
        final string =
            cartItems.where((element) => element.contains(cart[0])).first;
        cartItems.remove(string);
      } catch (e) {}

      cartItems.add(cart.toString());
      await sharedPreferences.setStringList("Cart", cartItems);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> removeCartItem(List<String> cart) async {
    try {
      final cartItems = getCartList();
      try {
        final str =
            cartItems.where((element) => element.contains(cart[0])).first;
        List<String> list3 = str.substring(1, str.length - 1).split(", ");
        int count = int.parse(list3[3]);
        if (count != 1) {
          count--;
          list3[3] = count.toString();
          cartItems.remove(str);
          cartItems.add(list3.toString());
        }
        else{
          cartItems.remove(str);
        }
      } catch (e) {}
      await sharedPreferences.setStringList("Cart", cartItems);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> removeCartList() async {
    try {
      await sharedPreferences.remove("Cart");
    } catch (e) {
      throw Exception(e);
    }
  }
}
