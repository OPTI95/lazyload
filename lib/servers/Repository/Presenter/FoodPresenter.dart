import 'package:lazyload/servers/Repository/FoodRepository.dart';

class FoodPresenter{
  final FoodRepository foodRepository;

  FoodPresenter(this.foodRepository);
  Future<List<Food>> getFoodList() async{
    try{
     return await foodRepository.getFoodList();
    }catch(e){
      throw Exception("Возникла ошибка ${e.toString()}");
    }
  }
}