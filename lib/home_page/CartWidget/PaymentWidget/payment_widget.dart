import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazyload/cubit/payment_cubit.dart';

import '../../../helpers/constans.dart';

class PaymentWidget extends StatefulWidget {
  final int price;
  PaymentWidget({super.key, required this.price});

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {

  var controllerNumber = new MaskedTextController(mask: '0000 0000 0000 0000');

  var controllerDate = new MaskedTextController(mask: '00/00');

  var controllerCVV = new MaskedTextController(mask: '000');

  int value = Random().nextInt(70000) + 60000;
  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {
    context.read<PaymentCubit>().get();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          return Scaffold(
            body: state is PaymentLoadedState
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.arrow_back_ios_new)),
                          ],
                        ),
                        Spacer(),
                        state.donePay == true
                            ? AnimatedTextKit(
                                animatedTexts: [
                                  WavyAnimatedText('Оплата прошла успешно!',
                                      textStyle: TextStyle(
                                          fontSize: 24,
                                          color: Colors.green[900])),
                                  WavyAnimatedText('Спасибо за покупку',
                                      textStyle: TextStyle(
                                          fontSize: 24,
                                          color: Colors.green[900])),
                                ],
                                isRepeatingAnimation: true,
                                onTap: () {},
                              )
                            : Text("Произошла ошибка на стороне банка"),
                        Spacer(),
                      ],
                    ),
                  ))
                : state is PaymentLoadingState
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.arrow_back_ios),
                                  splashRadius: 30,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Img.burgerImage,
                                  width: 50,
                                  height: 50,
                                ),
                                Text(
                                  "ОПТИ БАНК",
                                  style: GoogleFonts.federant(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.amber),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "OPTIFOOD",
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${widget.price} ₽",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Номер заказа: ${value}"),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Center(
                              child: SizedBox(
                                height: 380,
                                width: MediaQuery.of(context).size.width - 20,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Card(
                                    elevation: 5,
                                    shadowColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "По карте",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            height: 50,
                                            child: TextField(
                                              controller: controllerNumber,
                                              keyboardType:
                                                  TextInputType.number,
                                              cursorColor: Colors.amber[300],
                                              cursorWidth: 1,
                                              cursorHeight: 20,
                                              maxLength: 19,
                                              decoration: InputDecoration(
                                                suffixIcon: Icon(Icons.payment),
                                                counterText: "",
                                                contentPadding:
                                                    EdgeInsets.all(20),
                                                labelText: "Номер карты",
                                                labelStyle: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 15),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black26,
                                                            width: 1)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 1)),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller: controllerDate,
                                                    maxLength: 5,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    cursorColor:
                                                        Colors.amber[300],
                                                    cursorWidth: 1,
                                                    cursorHeight: 20,
                                                    decoration: InputDecoration(
                                                      counterText: "",
                                                      contentPadding:
                                                          EdgeInsets.all(20),
                                                      labelText: "Месяц/Год",
                                                      labelStyle: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .black26,
                                                                  width: 1)),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width:
                                                                          1)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: TextField(
                                                    controller: controllerCVV,
                                                    maxLength: 3,
                                                    obscureText: true,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    cursorColor:
                                                        Colors.amber[300],
                                                    cursorWidth: 1,
                                                    cursorHeight: 20,
                                                    decoration: InputDecoration(
                                                      counterText: "",
                                                      contentPadding:
                                                          EdgeInsets.all(20),
                                                      labelText: "CVC/CVV",
                                                      labelStyle: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 15),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .black26,
                                                                  width: 1)),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width:
                                                                          1)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  height: 50,
                                                  child: ElevatedButton(
                                                    onPressed: (controllerNumber
                                                                    .text
                                                                    .length !=
                                                                19 ||
                                                            controllerDate.text
                                                                    .length !=
                                                                5 ||
                                                            controllerCVV.text
                                                                    .length !=
                                                                3)
                                                        ? null
                                                        : () async{
                                                            await context
                                                                .read<
                                                                    PaymentCubit>()
                                                                .pay();
                                                          },
                                                    style: ButtonStyle(
                                                      shape:
                                                          MaterialStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "Оплатить",
                                                      style: TextStyle(
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Flex(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            direction: Axis.vertical,
                                            children: [
                                              Text(
                                                "Нажимая кнопку Оплатить, я соглашаюсь с условием ПАО ОптиБанк",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black38),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FaIcon(FontAwesomeIcons.ccVisa,
                                                  color: Colors.black38),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              FaIcon(
                                                  FontAwesomeIcons.ccMastercard,
                                                  color: Colors.black38),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              FaIcon(
                                                  FontAwesomeIcons.ccApplePay,
                                                  color: Colors.black38),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              FaIcon(FontAwesomeIcons.ccPaypal,
                                                  color: Colors.black38),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              FaIcon(FontAwesomeIcons.ccAmex,
                                                  color: Colors.black38)
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
          );
        },
      ),
    );
  }
}
