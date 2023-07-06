import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazyload/cubit/cart_cubit.dart';
import 'package:lazyload/cubit/coupon_cubit.dart';
import 'package:lazyload/cubit/food_cubit.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lazyload/home_page/CartWidget/PaymentWidget/payment_widget.dart';
import 'package:lazyload/home_page/MapWidget/map_widget.dart';
import 'package:lazyload/servers/Repository/CouponRepository.dart';

import 'package:lazyload/servers/Repository/FoodRepository.dart';
import 'package:msh_checkbox/msh_checkbox.dart';

import '../../helpers/constans.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  var coruselStream = StreamController<int>();
  var checkboxStream = StreamController<bool>();
  int num = 0;
  bool paymentTypeCard = true;
  bool paymentTypeCash = false;
  PersistentBottomSheetController? bottomSheetController;
  PersistentBottomSheetController? bottomSheetControllerChoosePayment;
  @override
  void initState() {
    final cartCubit = context.read<CartCubit>();
    cartCubit.getCartList();
    context.read<CouponCubit>().getCategories();
    super.initState();
  }

  @override
  void dispose() {
    coruselStream.close();
    checkboxStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CartCubit>().state;
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: CustomScrollView(slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                SizedBox(
                  height: 20,
                ),
                Text("Корзина",
                    style: GoogleFonts.actor(
                        fontSize: 28, fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        await context.read<CartCubit>().removeCartList();
                        await context.read<CartCubit>().getCartList();
                      },
                      child: Text(
                        "Очистить",
                        style: GoogleFonts.actor(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                )
              ])),
              state is CartLoadedState
                  ? (state.cartList.length == 0
                      ? SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Container(
                                height: 400,
                                child: Center(
                                  child: Text(
                                    "Корзина пуста!",
                                    style: GoogleFonts.adamina(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: state.cartList.length,
                            (context, index) {
                              if (state.cartList.length == 0) {
                              } else {
                                return CartItemWidget(index: index);
                              }
                            },
                          ),
                        ))
                  : SliverList(
                      delegate: SliverChildListDelegate(
                          [CircularProgressIndicator()])),
              BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  int price = 0;
                  if (state is CartLoadedState) {
                    state.cartList.forEach((element) {
                      List<String> list =
                          element.substring(1, element.length - 1).split(", ");
                      price += int.parse(list[1]) * int.parse(list[3]);
                    });
                    return SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Итог",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                price.toString() + "₽",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            height: 60,
                            indent: 10,
                            endIndent: 10,
                          ),
                          Text(
                            "Самовывоз из",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          state.addressRestaraunt == "" &&
                                  state.nameRestaraunt == ""
                              ? Text(
                                  "Ресторан не выбран!",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.amber),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (state).nameRestaraunt,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.amber),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      state.addressRestaraunt,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            "Заберу в",
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              bottomSheetController =
                                                  bottomSheet(context);
                                            },
                                            child: Text(
                                              context.read<CartCubit>().time ==
                                                          "" ||
                                                      context
                                                              .read<CartCubit>()
                                                              .time ==
                                                          "Сейчас"
                                                  ? "ближайшее время"
                                                  : context
                                                      .read<CartCubit>()
                                                      .time,
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      child: TextButton(
                                          onPressed: () {
                                            bottomSheetController =
                                                bottomSheet(context);
                                          },
                                          child: Text(
                                            "Изменить время",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          )),
                                    ),
                                  ],
                                ),
                          Divider(
                            thickness: 1,
                            height: 20,
                            indent: 10,
                            endIndent: 10,
                          ),
                          ListTileWidget(),
                          Divider(
                            thickness: 1,
                            height: 20,
                            indent: 10,
                            endIndent: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Электронная почта",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Чек придет по указанному адресу",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 50,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.bottom,
                                  style: TextStyle(fontSize: 16),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                      prefixIcon: Icon(Icons.email),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              width: 0,
                                              color: Colors.transparent)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            width: 0,
                                            color: Colors.transparent),
                                      ),
                                      hintText: "optifood@gmail.com",
                                      hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              DropdownButton(
                                  elevation: 0,
                                  borderRadius: BorderRadius.circular(30),
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  underline: Container(),
                                  isExpanded: true,
                                  value:
                                      context.read<CartCubit>().paymentCard ==
                                              true
                                          ? 1
                                          : 2,
                                  items: [
                                    DropdownMenuItem(
                                      value: 1,
                                      child: ListTile(
                                        leading: Image.asset(
                                          Img.burgerImage,
                                          height: 50,
                                          width: 50,
                                        ),
                                        title: Text(
                                          "Оплатить картой онлайн",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                        value: 2,
                                        child: ListTile(
                                          leading: Image.asset(
                                            Img.burgerImage,
                                            height: 50,
                                            width: 50,
                                          ),
                                          title: Text(
                                            "Оплатить наличными",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ))
                                  ],
                                  onChanged: (value) {
                                    if (value == 1) {
                                      context.read<CartCubit>().paymentCard =
                                          true;
                                    } else {
                                      context.read<CartCubit>().paymentCard =
                                          false;
                                    }
                                    setState(() {});
                                  }),
                              Divider(
                                thickness: 1,
                                height: 20,
                                indent: 10,
                                endIndent: 10,
                              ),
                              context.read<CartCubit>().paymentCard == true
                                  ? ListTile(
                                      title: Text(
                                        "Привязать карту к профилю",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      trailing: Switch(
                                          value: context
                                              .read<CartCubit>()
                                              .paymentCardSave,
                                          onChanged: (value) {
                                            setState(() {
                                              context
                                                  .read<CartCubit>()
                                                  .paymentCardSave = value;
                                            });
                                          }),
                                    )
                                  : Container(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 55,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)))),
                                          onPressed: () {
                                            Navigator.push<void>(
                                              context,
                                              MaterialPageRoute<void>(
                                                  builder:
                                                      (BuildContext context) =>
                                                          PaymentWidget(
                                                            price: price,
                                                          )),
                                            );
                                          },
                                          child: Text(
                                              "Оплатить заказ на $price ₽",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              )
                              // Align(
                              //   alignment: Alignment.center,
                              //   child: InkWell(
                              //     onTap: () {
                              //       bottomSheetControllerChoosePayment =
                              //           Scaffold.of(context).showBottomSheet(
                              //             enableDrag: false,
                              //               backgroundColor: Colors.transparent,
                              //               (context) {
                              //         return Container(
                              //           height: 200,
                              //           decoration: BoxDecoration(
                              //             borderRadius: BorderRadius.only(
                              //                 topLeft: Radius.circular(30),
                              //                 topRight: Radius.circular(30)),
                              //             color: Colors.white,
                              //           ),
                              //           child: Padding(
                              //             padding: const EdgeInsets.symmetric(
                              //                 horizontal: 20, vertical: 10),
                              //             child: Column(
                              //               children: [
                              //                 Row(
                              //                   children: [
                              //                     Align(
                              //                         alignment:
                              //                             Alignment.center,
                              //                         child: Text(
                              //                           "Способ оплаты",
                              //                           style: TextStyle(
                              //                               fontSize: 18,
                              //                               fontWeight:
                              //                                   FontWeight
                              //                                       .bold),
                              //                         )),
                              //                     Spacer(),
                              //                     Align(
                              //                       alignment:
                              //                           Alignment.centerRight,
                              //                       child: CircleAvatar(
                              //                         radius: 15,
                              //                         backgroundColor:
                              //                             Colors.grey[300],
                              //                         child: IconButton(
                              //                             splashRadius: 16,
                              //                             icon: Icon(
                              //                               Icons.close,
                              //                               size: 15,
                              //                               color: Colors.white,
                              //                             ),
                              //                             onPressed: () async {
                              //                               checkboxStream
                              //                                   .close();
                              //                               bottomSheetControllerChoosePayment
                              //                                   ?.close();
                              //                             }),
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //                 StreamBuilder<Object>(
                              //                     stream: checkboxStream.stream,
                              //                     initialData: true,
                              //                     builder: (context, snapshot) {
                              //                       return Column(
                              //                         children: [
                              //                           Align(
                              //                             alignment: Alignment
                              //                                 .centerLeft,
                              //                             child: Row(
                              //                               mainAxisSize:
                              //                                   MainAxisSize
                              //                                       .min,
                              //                               mainAxisAlignment:
                              //                                   MainAxisAlignment
                              //                                       .start,
                              //                               children: [
                              //                                 Image.asset(
                              //                                   Img.burgerImage,
                              //                                   width: 50,
                              //                                   height: 50,
                              //                                 ),
                              //                                 Text(
                              //                                   "Оплатить картой онлайн",
                              //                                   style: TextStyle(
                              //                                       fontSize:
                              //                                           16,
                              //                                       fontWeight:
                              //                                           FontWeight
                              //                                               .w500),
                              //                                 ),
                              //                                 Spacer(),
                              //                                 MSHCheckbox(
                              //                                   size: 25,
                              //                                   value: paymentTypeCash == true? false:
                              //                                       paymentTypeCard,
                              //                                   colorConfig:
                              //                                       MSHColorConfig
                              //                                           .fromCheckedUncheckedDisabled(
                              //                                     checkedColor:
                              //                                         Colors
                              //                                             .amber,
                              //                                   ),
                              //                                   style: MSHCheckboxStyle
                              //                                       .fillScaleColor,
                              //                                   onChanged:
                              //                                       (selected) {
                              //                                     setState(() {
                              //                                       paymentTypeCard =
                              //                                           selected;
                              //                                     });
                              //                                     checkboxStream
                              //                                         .sink
                              //                                         .add(
                              //                                             selected);
                              //                                     context
                              //                                             .read<
                              //                                                 CartCubit>()
                              //                                             .paymentCard =
                              //                                         selected;
                              //                                   },
                              //                                 )
                              //                               ],
                              //                             ),
                              //                           ),
                              //                           Align(
                              //                             alignment: Alignment
                              //                                 .centerLeft,
                              //                             child: Row(
                              //                               mainAxisSize:
                              //                                   MainAxisSize
                              //                                       .min,
                              //                               mainAxisAlignment:
                              //                                   MainAxisAlignment
                              //                                       .start,
                              //                               children: [
                              //                                 Image.asset(
                              //                                   Img.burgerImage,
                              //                                   width: 50,
                              //                                   height: 50,
                              //                                 ),
                              //                                 Text(
                              //                                   "Оплатить наличными",
                              //                                   style: TextStyle(
                              //                                       fontSize:
                              //                                           16,
                              //                                       fontWeight:
                              //                                           FontWeight
                              //                                               .w500),
                              //                                 ),
                              //                                 Spacer(),
                              //                                 MSHCheckbox(
                              //                                   size: 25,
                              //                                   value:
                              //                                       paymentTypeCard == true? false: paymentTypeCash,
                              //                                   colorConfig:
                              //                                       MSHColorConfig
                              //                                           .fromCheckedUncheckedDisabled(
                              //                                     checkedColor:
                              //                                         Colors
                              //                                             .amber,
                              //                                   ),
                              //                                   style: MSHCheckboxStyle
                              //                                       .fillScaleColor,
                              //                                   onChanged:
                              //                                       (selected) {
                              //                                     setState(() {
                              //                                       paymentTypeCash =
                              //                                           selected;
                              //                                     });
                              //                                     checkboxStream
                              //                                         .sink
                              //                                         .add(
                              //                                             selected);
                              //                                     context
                              //                                             .read<
                              //                                                 CartCubit>()
                              //                                             .paymentCard =
                              //                                         !selected;
                              //                                   },
                              //                                 )
                              //                               ],
                              //                             ),
                              //                           ),
                              //                         ],
                              //                       );
                              //                     }),
                              //                 Row(
                              //                   children: [
                              //                     Expanded(
                              //                         child: ElevatedButton(
                              //                             onPressed: () async{
                              //                               await checkboxStream
                              //                                   .close();
                              //                               bottomSheetControllerChoosePayment?.close();
                              //                             },
                              //                             child: Text(
                              //                               "Готово",
                              //                               style: TextStyle(
                              //                                   fontSize: 20),
                              //                             ))),
                              //                   ],
                              //                 )
                              //               ],
                              //             ),
                              //           ),
                              //         );
                              //       });
                              //     },
                              //     child: Row(
                              //       mainAxisSize: MainAxisSize.min,
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         Image.asset(
                              //           Img.burgerImage,
                              //           width: 50,
                              //           height: 50,
                              //         ),
                              //         Text(
                              //           "Оплатить картой онлайн",
                              //           style: TextStyle(
                              //               fontSize: 16,
                              //               fontWeight: FontWeight.w500),
                              //         ),
                              //         Icon(
                              //           Icons.keyboard_arrow_down,
                              //           color: Colors.grey,
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // )
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    return SliverList(
                      delegate: SliverChildListDelegate([Container()]),
                    );
                  }
                },
              )
            ])),
      ),
    ));
  }

  PersistentBottomSheetController<dynamic> bottomSheet(BuildContext context) {
    return Scaffold.of(context).showBottomSheet(
        enableDrag: false, backgroundColor: Colors.transparent, (context) {
      List<String> timeList = time();
      return Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 141,
                child: Container(
                    alignment: Alignment.topCenter,
                    width: 70,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                        border: Border.all(color: Colors.amber, width: 2))),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Время самовывоза",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w800),
                      ),
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.grey[300],
                        child: IconButton(
                            splashRadius: 18,
                            icon: Icon(
                              Icons.close,
                              size: 17,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              await coruselStream.close();
                              coruselStream = StreamController<int>();
                              num = 0;
                              bottomSheetController?.close();
                            }),
                      ),
                    ],  
                  ),
                  Spacer(),
                  StreamBuilder<Object>(
                    stream: coruselStream.stream,
                    initialData: num,
                    builder: (context, snapshot) {
                      return Container(
                        child: CarouselSlider.builder(
                            itemCount: timeList.length,
                            itemBuilder: ((context, index, realIndex) {
                              timeList[0] = "Сейчас";
                              return Text(
                                timeList[index],
                                style: TextStyle(
                                    color: snapshot.data == index
                                        ? Colors.amber
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              );
                            }),
                            options: CarouselOptions(
                                initialPage: num,
                                onPageChanged: (index, reason) {
                                  print(timeList[index]);
                                  num = index;
                                  setState(() {});
                                  context.read<CartCubit>().time =
                                      timeList[index];
                                  coruselStream.sink.add(index);
                                },
                                enlargeCenterPage: true,
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.scale,
                                enlargeFactor: 0.2,
                                height: 50,
                                viewportFraction: 0.2,
                                enableInfiniteScroll: false,
                                aspectRatio: 1 / 2)),
                      );
                    },
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await coruselStream.close();
                            coruselStream = StreamController<int>();

                            bottomSheetController?.close();
                          },
                          child: Text(
                            "Готово",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class CashCheckBox extends StatefulWidget {
  const CashCheckBox({super.key});

  @override
  State<CashCheckBox> createState() => _CashCheckBoxState();
}

class _CashCheckBoxState extends State<CashCheckBox> {
  @override
  Widget build(BuildContext context) {
    return MSHCheckbox(
      size: 25,
      value: !context.read<CartCubit>().paymentCard,
      colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
        checkedColor: Colors.amber,
      ),
      style: MSHCheckboxStyle.fillScaleColor,
      onChanged: (selected) {
        setState(() {
          context.read<CartCubit>().paymentCard = !selected;
        });
      },
    );
  }
}

class CartCheckBox extends StatefulWidget {
  const CartCheckBox({super.key});

  @override
  State<CartCheckBox> createState() => _CartCheckBoxState();
}

class _CartCheckBoxState extends State<CartCheckBox> {
  @override
  Widget build(BuildContext context) {
    return MSHCheckbox(
      size: 25,
      value: context.read<CartCubit>().paymentCard,
      colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
        checkedColor: Colors.amber,
      ),
      style: MSHCheckboxStyle.fillScaleColor,
      onChanged: (selected) {
        setState(() {
          context.read<CartCubit>().paymentCard = selected;
        });
      },
    );
  }
}

class ListTileWidget extends StatefulWidget {
  ListTileWidget({
    super.key,
  });
  bool val = true;
  @override
  State<ListTileWidget> createState() => _ListTileWidgetState();
}

class _ListTileWidgetState extends State<ListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.fastfood_outlined,
        size: 35,
        color: Colors.black,
      ),
      title: Text("Упаковать с собой"),
      subtitle: Text(
        "Бесплатно",
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      trailing: Switch(
          value: widget.val,
          onChanged: (value) {
            context.read<CartCubit>().packet = value;
            setState(() {
              widget.val = value;
            });
          }),
    );
  }
}

List<String> time() {
  DateTime now = DateTime.now();
  int currentMinute = now.minute;
  int remainder = currentMinute % 5;
  int startMinute =
      remainder == 0 ? currentMinute : currentMinute + (5 - remainder);
  List<String> timeList = [];
  for (int i = 0; i < 12; i++) {
    int minute = startMinute + (i * 5);
    int hourOffset = (minute ~/ 60);
    int hour = (now.hour + hourOffset) % 24;
    minute = minute % 60;
    DateTime time = DateTime(now.year, now.month, now.day, hour, minute);
    String formattedTime = DateFormat.Hm().format(time);
    timeList.add(formattedTime);
  }
  return timeList;
}

class CartItemWidget extends StatelessWidget {
  CartItemWidget({
    super.key,
    required this.index,
  });

  final int index;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(builder: (context, snapshot) {
      String str = (snapshot as CartLoadedState).cartList[index];
      List<String> list = str.substring(1, str.length - 1).split(", ");
      return Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Image.network(
                list[2],
                width: 60,
                height: 60,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: 150,
                      child: Text(
                        list[0],
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis),
                        softWrap: true,
                        maxLines: 2,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    list[1].toString() + "₽",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              Spacer(),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[200],
                child: IconButton(
                    splashRadius: 22,
                    icon: Icon(
                      Icons.remove,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      final cartCubit = context.read<CartCubit>();
                      final foodCubitState = context.read<FoodCubit>().state;
                      try {
                        if (foodCubitState is FoodLoadedState) {
                          List<Food> listFood = foodCubitState.foodList;
                          Food food = listFood
                              .where((element) => element.nameFood == list[0])
                              .first;
                          await cartCubit.removeCart(food, false);
                          await cartCubit.getCartList();
                        }
                      } catch (e) {
                        final statecoupon = context.read<CouponCubit>().state;
                        if (statecoupon is CouponLoadedState) {
                          List<CouponFoodList> listFood =
                              statecoupon.couponList;
                          CouponFoodList couponFoodList = listFood
                              .where(
                                  (element) => element.couponNumber == list[0])
                              .first;
                          Food food = (context.read<CouponCubit>().state
                                  as CouponLoadedState)
                              .couponList[index]
                              .food
                              .first;

                          await cartCubit.removeCart(
                              food, true, couponFoodList);
                          await cartCubit.getCartList();
                        }
                      }
                    }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  list[3],
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[200],
                child: IconButton(
                  splashRadius: 22,
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    final cartCubit = context.read<CartCubit>();
                    final foodCubitState = context.read<FoodCubit>().state;
                    try {
                      if (foodCubitState is FoodLoadedState) {
                        List<Food> listFood = foodCubitState.foodList;
                        Food food = listFood
                            .where((element) => element.nameFood == list[0])
                            .first;
                        await cartCubit.setCartList(food, false);
                        await cartCubit.getCartList();
                      }
                    } catch (e) {
                      final statecoupon = context.read<CouponCubit>().state;
                      if (statecoupon is CouponLoadedState) {
                        List<CouponFoodList> listFood = statecoupon.couponList;
                        CouponFoodList couponFoodList = listFood
                            .where((element) => element.couponNumber == list[0])
                            .first;
                        Food food = (context.read<CouponCubit>().state
                                as CouponLoadedState)
                            .couponList[index]
                            .food
                            .first;

                        await cartCubit.setCartList(food, true, couponFoodList);
                        await cartCubit.getCartList();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
