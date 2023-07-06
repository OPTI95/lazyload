import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazyload/RegistrationAccount/pick_favorite_food.dart';
import 'package:lazyload/cubit/login_cubit.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import '../home_page/home.dart';

class SendCodeWidget extends StatefulWidget {
  const SendCodeWidget({super.key});

  @override
  State<SendCodeWidget> createState() => _SendCodeWidgetState();
}

class _SendCodeWidgetState extends State<SendCodeWidget> {
  TextEditingController controller = TextEditingController();
  PinDecoration _pinDecoration = BoxTightDecoration(
      hintText: "0000",
      strokeColor: Colors.black,
      textStyle: TextStyle(color: Colors.amber, fontSize: 20));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [WelcomeTextWidget()],
                ),
                CircleWidget(),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Подтверждение почты",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  height: 10,
                ),
                const DividerWidget(),
                const SizedBox(
                  height: 50,
                ),
                const Text("Мы отправили код на почту"),
                Text(context.read<LoginCubit>().userReg.emailUser),
                TextButton(
                    onPressed: () async{
                      await context.read<LoginCubit>().sendEmail();
                    }, child: const Text("Отправить снова")),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: PinInputTextField(
                    controller: controller,
                    decoration: _pinDecoration,
                    pinLength: 4,
                    onSubmit: ((value) => {print(value)}),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Вернуться")),
                    ElevatedButton(
                        onPressed: () async{
                         bool check= await context.read<LoginCubit>().addUser(controller);
                         check == true?
                          Navigator.push(context, createRoute()):print("");
                        } ,
                        child: const Text("Продолжить")),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}Route createRoute() {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 500),
    pageBuilder: (_, __, ___) => HomeWidget(),
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(curve: Curves.fastOutSlowIn, parent: animation)),
          child: child,
        ),
      );
    },
  );
}

class DividerWidget extends StatelessWidget {
  const DividerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 2,
      indent: 30,
      endIndent: 30,
      color: Colors.amber,
    );
  }
}

class WelcomeTextWidget extends StatelessWidget {
  const WelcomeTextWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 70, bottom: 30),
        child: RichText(
            textDirection: TextDirection.ltr,
            text: TextSpan(
              text: "OPTI",
              style:
                  GoogleFonts.abrilFatface(fontSize: 40, color: Colors.black54),
              children: <TextSpan>[
                const TextSpan(
                    text: "FOOD",
                    style: TextStyle(color: Color.fromARGB(248, 220, 171, 8))),
                const TextSpan(
                    text: "🍔",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            )));
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class CircleWidget extends StatelessWidget {
  const CircleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90), color: Colors.black),
          width: 8,
          height: 8,
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90), color: Colors.black),
          width: 8,
          height: 8,
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90), color: Colors.black),
          width: 8,
          height: 8,
        ),
      ],
    );
  }
}
