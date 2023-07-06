import 'package:bloc/bloc.dart';
import 'package:lazyload/servers/Repository/Presenter/CategoryPresenter.dart';
import 'package:meta/meta.dart';

import '../servers/Repository/CategoryRepository.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitialState());
  Future<void> getCategories()async{
    emit(CategoryLoadingState());
    CategoryPresenter _categoryPresenter =  CategoryPresenter(CategoryRepository());
    List<Category> categoryList = await _categoryPresenter.getFoodList();
    print("ВЫЗВАЛ ПОЛУЧЕНИЕ КАТЕГОРИЙ!");
    emit(CategoryLoadedState(categoriesList: categoryList));
  }
}
