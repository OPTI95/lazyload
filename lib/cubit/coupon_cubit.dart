import 'package:bloc/bloc.dart';
import 'package:lazyload/servers/Repository/Presenter/CouponPresenter.dart';
import 'package:meta/meta.dart';

import '../servers/Repository/CouponRepository.dart';

part 'coupon_state.dart';

class CouponCubit extends Cubit<CouponState> {
  CouponCubit() : super(CouponInitial());
   Future<void> getCategories()async{
    emit(CouponLoadingState());
    CouponPresenter _couponPresenter =  CouponPresenter(CouponRepository());
    List<CouponFoodList> couponList = await _couponPresenter.getCouponList();
    emit(CouponLoadedState(couponList: couponList));
  }
}
