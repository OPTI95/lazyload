part of 'category_cubit.dart';

@immutable
abstract class CategoryState {}
class CategoryInitialState extends CategoryState{}
class CategoryLoadingState extends CategoryState {}
class CategoryLoadedState extends CategoryState {
  final List<Category> categoriesList;

  CategoryLoadedState({required this.categoriesList});
}

