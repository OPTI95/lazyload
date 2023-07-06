import 'package:lazyload/servers/Repository/CouponRepository.dart';

class CouponPresenter{
  final CouponRepository couponRepository;

  CouponPresenter(this.couponRepository);
  Future<List<CouponFoodList>> getCouponList() async{
    try{
     return await couponRepository.getListCoupon();
    }catch(e){
      throw Exception("Возникла ошибка ${e.toString()}");

    }
   
  }
}