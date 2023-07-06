import 'package:lazyload/servers/Repository/CartRepository.dart';

class CartPresenter {
  final CartRepository cartRepository;

  CartPresenter(this.cartRepository);
  List<String> getCartList() {
    try {
      return cartRepository.getCartList();
    } catch (e) {
      throw Exception("Возникла ошибка ${e.toString()}");
    }
  }
  Future<bool> saveRestaraunt(String name)async{
     try {
      return await cartRepository.saveRestaraunt(name);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> saveAddressRestaraunt(String name)async{
     try {
      return await cartRepository.saveAddressRestaraunt(name);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> removeCartItem(List<String> cart) async {
    try {
      await cartRepository.removeCartItem(cart);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> removeCartList() async {
    try {
      await cartRepository.removeCartList();
    } catch (e) {
      throw Exception(e);
    }
  }  


  Future<void> setCartList(List<String> cart) async {
    try {
      await cartRepository.setCartList(cart);
    } catch (e) {
      throw Exception(e);
    }
  }


   List<String> getRestaraunt()  {
    try {
      return  cartRepository.getRestaraut();
    } catch (e) {
      throw Exception("Возникла ошибка ${e.toString()}");
    }
  }
}
