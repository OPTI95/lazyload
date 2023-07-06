import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazyload/cubit/cart_cubit.dart';
import 'package:lazyload/cubit/category_cubit.dart';
import 'package:lazyload/cubit/coupon_cubit.dart';
import 'package:lazyload/cubit/food_cubit.dart';
import 'package:lazyload/cubit/login_cubit.dart';
import 'package:lazyload/home_page/MenuWidget/more_info_food.dart';
import '../../helpers/constans.dart';
import '../../servers/Repository/FoodRepository.dart';

class MenuWidget extends StatelessWidget {
  MenuWidget({
    Key? key,
  }) : super(key: key);
  final List<GlobalKey> keys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey()
  ];
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  CustomScrollView(
          controller: scrollController,
          slivers: [
            BlocBuilder<CouponCubit, CouponState>(builder: (context, snapshot) {
              if (snapshot is CouponLoadedState) {
                return SliverList(
                    delegate: SliverChildBuilderDelegate(childCount: 1,
                        (context, index) {
                  if (index == 0) {
                    return HomeMarketing();
                  }
                }));
              } else {
                context.read<CouponCubit>().getCategories();
                return SliverList(delegate: SliverChildListDelegate([Center(
                  child: RefreshProgressIndicator(),
                )]));
              }
            }),
            BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
              if (state is CategoryInitialState) {
                context.read<CategoryCubit>().getCategories();
              } else if (state is CategoryLoadedState) {
                return SliverPersistentHeader(
                  pinned: true,
                  delegate: MyHeaderDelegate(
                      scrollController: scrollController, key: keys),
                );
              }

              return SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: 1,
                      (context, index) => Center(child: Container())));
            }),
            BlocBuilder<FoodCubit, FoodState>(builder: (context, state) {
              final states = context.watch<CategoryCubit>().state;
              if (state is FoodInitialState) {
                context.read<FoodCubit>().getFoods();
              } else if (state is FoodLoadedState &&
                  states is CategoryLoadedState) {
                return SliverList(
                  delegate: SliverChildListDelegate([
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: states.categoriesList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                            key: keys[index],
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                    states.categoriesList[index].nameCategory,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                              ),
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: state.foodList.length,
                                  itemBuilder: (context, index2) {
                                    if (state.foodList[index2].categoryId ==
                                        states
                                            .categoriesList[index].idCategory) {
                                      return Column(children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        FoodsWidget(index: index2),
                                      ]);
                                    } else {
                                      return Container();
                                    }
                                  })
                            ],
                          ),
                        );
                      },
                    )
                  ]),
                );
              }
              return SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: 1,
                      (context, index) => Center(child: Container())));
            })
          ],
        ),
    );
  }
}

class HomeMarketing extends StatelessWidget {
  const HomeMarketing({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const UpWelcomeNameWidget(),
        SizedBox(height: 30),
        Container(
          height: 200,
          child: ListView.separated(
              itemCount:
                  (context.watch<CouponCubit>().state as CouponLoadedState)
                      .couponList
                      .length,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => SizedBox(
                    width: 5,
                  ),
              itemBuilder: ((context, index) {
                return MyWidget(
                  index: index,
                );
              })),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class FoodsWidget extends StatelessWidget {
  final int index;
  const FoodsWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodCubit, FoodState>(
      builder: (context, state) {
        state as FoodLoadedState;
        return InkWell(
          onTap: () {
            Food food = state.foodList[index];
            Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => MoreInfoFoodWidget(
                  food: food,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Image(
                  image: NetworkImage(state.foodList[index].imageFood!),
                  width: 150,
                  height: 150,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 150,
                        height: 50,
                        child: Text(
                          state.foodList[index].nameFood,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        )),
                    BlocConsumer<CartCubit, CartState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        final bloc = context.read<CartCubit>();
                        final states = context.read<FoodCubit>().state;
                        states as FoodLoadedState;
                        return ElevatedButton(
                          onPressed: () async {
                            final states = context.read<FoodCubit>().state;
                            states as FoodLoadedState;
                            Food food = states.foodList[index];
                            await bloc.setCartList(food, false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Добавил в корзину'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Text(
                            states.foodList[index].priceFood.toString() + " ₽",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.all(Size(100, 40)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey[100])),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class MyWidget extends StatelessWidget {
  final int index;
  MyWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        width: 150,
        child: Column(children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Image.network(
                (context.read<CouponCubit>().state as CouponLoadedState)
                    .couponList[index]
                    .imageLink,
                fit: BoxFit.contain,
                height: 200,
              ),
              Text((context.read<CouponCubit>().state as CouponLoadedState)
                    .couponList[index]
                    .couponNumber, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
            ],
          )
        ]),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        clipBehavior: Clip.hardEdge,
      ),
    );
  }
}

DateTime now = DateTime.now();

class UpWelcomeNameWidget extends StatelessWidget {
  const UpWelcomeNameWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<LoginCubit>().state;
    state as LoginLoadedState;
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      SizedBox(
        width: 20,
      ),
      state.user.profileImageUser == null
          ? CircleAvatar(
              backgroundImage: AssetImage(Img.burgerImage),
              radius: 30,
            )
          : CircleAvatar(
              backgroundImage: NetworkImage(state.user.profileImageUser!),
              radius: 30,
            ),
      SizedBox(
        width: 20,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // index == 0
          //   ? MenuWidget()
          //   : (index == 1 ? DiscountWidget() : MapWidget()));
          now.hour > 5 && now.hour < 12
              ? Text("Доброе утро")
              : (now.hour >= 12 && now.hour < 18
                  ? Text("Добрый день")
                  : (now.hour >= 18 && now.hour < 21
                      ? Text("Добрый вечер")
                      : Text("Доброй ночи"))),
          SizedBox(
            height: 5,
          ),
          Text(state.user.nameUser)
        ],
      ),
      Spacer(),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.menu),
        splashRadius: 20,
      )
    ]);
  }
}

// class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
//   final ScrollController scrollController;
//   final List<Category> categoriesList;

//   MyHeaderDelegate({
//     required this.scrollController,
//     required this.categoriesList,
//   });

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Colors.white,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: categoriesList.map((category) {
//             final key = GlobalKey();
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: GestureDetector(
//                 onTap: () {
//                   scrollController.animateTo(
//                     key.currentContext!
//                         .findRenderObject()!
//                         .getTransformTo(null)
//                         .getTranslation()
//                         .y,
//                     duration: Duration(milliseconds: 500),
//                     curve: Curves.easeInOut,
//                   );
//                 },
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(category.nameCategory),
//                     SizedBox(height: 5),
//                     Container(
//                       width: 2,
//                       height: 10,
//                       color: Colors.black,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   @override
//   double get maxExtent => 400;

//   @override
//   double get minExtent => 50;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return true;
//   }
// }

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final ScrollController scrollController;
  final List<GlobalKey> key;
  MyHeaderDelegate({required this.scrollController, required this.key});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        state as CategoryLoadedState;
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.categoriesList.length,
            itemBuilder: (BuildContext context, int index) {
              return TextButton(
                  onPressed: () async {
                    try {
                      scrollController.animateTo(
                          key[index]
                                  .currentContext!
                                  .findRenderObject()!
                                  .getTransformTo(null)
                                  .getTranslation()
                                  .y -
                              70,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    } catch (e) {
                      await context.read<FoodCubit>().getFoods();
                    }
                  },
                  child: context.read<CategoryCubit>().state
                          is CategoryLoadedState
                      ? Text(
                          state.categoriesList[index].nameCategory,
                          style: TextStyle(fontSize: 17, color: Colors.black45),
                        )
                      : Text(""));
            },
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
