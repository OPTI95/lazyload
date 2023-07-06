import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazyload/Login/RememberPassword/remember_new_password_widget.dart';
import 'package:lazyload/cubit/login_cubit.dart';
import 'package:lazyload/home_page/home.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class RememberPasswordCodeWidget extends StatelessWidget {
  MaskedTextController textController = new MaskedTextController(mask: "0000");
  RememberPasswordCodeWidget({Key? key}) : super(key: key);

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
                const Text(
                  "Сброс пароля",
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
                    onPressed: () {}, child: const Text("Отправить снова")),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: PinInputTextField(
                    controller: textController,
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
                        onPressed: () async {
                          bool check = context.read<LoginCubit>().code.toString() == textController.unmasked.toString();
                          if (check) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewPasswordWidget()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                backgroundColor: Colors.amber,
                                content: Text('Неверный код'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
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
        margin: const EdgeInsets.symmetric(vertical: 70),
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
