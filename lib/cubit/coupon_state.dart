part of 'coupon_cubit.dart';

@immutable
abstract class CouponState {}

class CouponInitial extends CouponState {}
class CouponLoadingState extends CouponState {}
class CouponLoadedState extends CouponState {
  final List<CouponFoodList> couponList;

  CouponLoadedState({required this.couponList});
}

