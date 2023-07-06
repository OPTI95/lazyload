import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazyload/cubit/coupon_cubit.dart';
import 'package:lazyload/servers/Repository/CouponRepository.dart';

import '../../cubit/cart_cubit.dart';
import '../../helpers/constans.dart';
import '../../servers/Repository/FoodRepository.dart';

class DiscountWidget extends StatelessWidget {
  const DiscountWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CouponCubit, CouponState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: state is CouponLoadedState
                ? CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.transparent,
                        centerTitle: true,
                        title: Text(
                          "Купоны",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                              childCount: state.couponList.length,
                              (context, index) {
                        return CardDiscountWidget(
                          index: index,
                        );
                      }))
                    ],
                  )
                // ? Column(
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 20),
                //         child: Text(
                //           "Купоны",
                //           style: TextStyle(
                //               fontWeight: FontWeight.bold, fontSize: 30),
                //         ),
                //       ),

                //     ],
                //   )
                : state is CouponInitial
                    ? ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          context.read<CouponCubit>().getCategories();
                          Center(
                            child: CircularProgressIndicator(),
                          );
                        })
                    : Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}

class CardDiscountWidget extends StatelessWidget {
  final int index;
  const CardDiscountWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
      child: Container(
        height: 330,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageDiscountCardWidget(
              index: index,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  ChipsDiscountCardWidget(index: index),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 5,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 40,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 5,
                                height: 2,
                                color: Colors.grey,
                              ),
                            ],
                          );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      CodeDiscountCardWidget(index: index),
                      Spacer(),
                      ButtonBuyDiscountCardWidget(index: index)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonBuyDiscountCardWidget extends StatelessWidget {
  final int index;

  const ButtonBuyDiscountCardWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CouponCubit, CouponState>(
      builder: (context, state) {
        return SizedBox(
          height: 50,
          child: ElevatedButton(
              onPressed: () async {
                Food food = (context.read<CouponCubit>().state as CouponLoadedState).couponList[index].food.first;
                CouponFoodList couponFoodList = (context.read<CouponCubit>().state as CouponLoadedState).couponList[index];
                await context.read<CartCubit>().setCartList(food, true,couponFoodList);
              },
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.redAccent[700])),
              child: Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    new TextSpan(
                        text: state is CouponLoadedState
                            ? state.couponList[index].salePriceCoupone
                                    .toString() +
                                " ₽ "
                            : "",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                    new TextSpan(
                      text: state is CouponLoadedState
                          ? state.couponList[index].priceCoupone.toString() +
                              " ₽ "
                          : "",
                      style: new TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}

class CodeDiscountCardWidget extends StatelessWidget {
  final int index;

  const CodeDiscountCardWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CouponCubit, CouponState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Купон"),
            Text(
              (state as CouponLoadedState)
                  .couponList[index]
                  .couponNumber
                  .toString(),
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }
}

class ChipsDiscountCardWidget extends StatelessWidget {
  final int index;

  const ChipsDiscountCardWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CouponCubit, CouponState>(
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  (context.read<CouponCubit>().state as CouponLoadedState)
                      .couponList[index]
                      .food
                      .length,
              itemBuilder: (context, index2) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Chip(
                      label: Text((context.read<CouponCubit>().state
                                  as CouponLoadedState)
                              .couponList[index]
                              .food[index2]
                              .count
                              .toString() +
                          "x" +
                          " " +
                          (context.read<CouponCubit>().state
                                  as CouponLoadedState)
                              .couponList[index]
                              .food[index2]
                              .nameFood)),
                );
              }),
        );
      },
    );
  }
}

class ImageDiscountCardWidget extends StatelessWidget {
  final int index;

  const ImageDiscountCardWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.white),
          width: 300,
          height: 150,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                (context.read<CouponCubit>().state as CouponLoadedState)
                    .couponList[index]
                    .imageLink,
                fit: BoxFit.contain,
              ))),
    );
  }
}
