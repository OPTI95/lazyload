part of 'cart_cubit.dart';

@immutable
abstract class CartState {}
class CartInitialState extends CartState {}
class CartLoadingState extends CartState {}
class CartLoadedState extends CartState {
  final List<String> cartList;
  final String nameRestaraunt;
  final String addressRestaraunt;
  CartLoadedState(this.cartList, this.nameRestaraunt, this.addressRestaraunt);
}
class CartUnLoadingState extends CartState {}

class CartUnLoadedState extends CartState {}

