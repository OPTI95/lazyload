part of 'food_cubit.dart';

@immutable
abstract class FoodState {}

class FoodInitialState extends FoodState{
}
 
class FoodLoadedState extends FoodState {
  final List<Food> foodList;

  FoodLoadedState({required this.foodList});
}
class FoodLoadingState extends FoodState {}


