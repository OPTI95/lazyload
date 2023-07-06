
import 'package:lazyload/servers/Repository/CategoryRepository.dart';

class CategoryPresenter{
  final CategoryRepository categoryRepository;

  CategoryPresenter(this.categoryRepository);
  Future<List<Category>> getFoodList() async{
    try{
     return await categoryRepository.getCategoryList();
    }catch(e){
      throw Exception("Возникла ошибка ${e.toString()}");

    }
   
  }
}