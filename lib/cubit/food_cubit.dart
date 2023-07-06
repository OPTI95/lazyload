import 'package:bloc/bloc.dart';
import 'package:lazyload/servers/Repository/FoodRepository.dart';
import 'package:lazyload/servers/Repository/Presenter/FoodPresenter.dart';
import 'package:meta/meta.dart';

part 'food_state.dart';

class FoodCubit extends Cubit<FoodState> {
  FoodCubit() : super(FoodInitialState());
  Future<void> getFoods()async{
    emit(FoodLoadingState());
    FoodPresenter _foodPresenter =  FoodPresenter(FoodRepository());
    List<Food> foodList = await _foodPresenter.getFoodList();
    emit(FoodLoadedState(foodList: foodList));
  }
}
