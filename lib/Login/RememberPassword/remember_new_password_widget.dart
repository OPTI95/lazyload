import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazyload/cubit/login_cubit.dart';

class NewPasswordWidget extends StatelessWidget {
  MaskedTextController textController = new MaskedTextController(
      mask: "№№№№№№№№№№№№№№№№№№№№№",
      translator: {'№': RegExp(r"[a-z0-9!#$%&? ]")});
  final textEditingController = new TextEditingController();
  NewPasswordWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
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
                    height: 30,
                  ),
                  const TextWidget(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(children: [
                      TextField(
                        controller: textController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    const Radius.circular(10))),
                            hintText: "Введите пароль",
                            suffixIcon: const Icon(Icons.lock_outline_rounded),
                            label: Column(
                              children: [const Text("Пароль")],
                            ),
                            helperText: "Минимум 8 символов",
                            helperStyle:
                                const TextStyle(color: Colors.black45)),
                        // counterText: "Минимум 8"),
                        maxLength: 21,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      )
                    ]),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {}, child: const Text("Вернуться")),
                      ElevatedButton(
                          onPressed: () {
                            if (textController.unmasked ==
                                textEditingController.text) {
                              if (textController.unmasked.length > 7) {
                                context
                                    .read<LoginCubit>()
                                    .changePasswordUser(textController);
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  backgroundColor: Colors.amber,
                                  content: Text('Пароль должен быть не менее 8 символов'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  backgroundColor: Colors.amber,
                                  content: Text('Пароли не совпадают'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                          child: const Text("Восстановить"))
                    ],
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        width: 280,
        height: 130,
        child: Flexible(
            child: Text(
          "Отлично, теперь вы можете сбросить свой пароль. Чтобы повысить безопасность вашего пароля, используйте комбинацию прописных букв, цифр и специальных символов",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        )));
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
              children: const <TextSpan>[
                TextSpan(
                    text: "FOOD",
                    style: TextStyle(color: Color.fromARGB(248, 220, 171, 8))),
                TextSpan(
                    text: "🍔",
                    style: TextStyle(
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


// remove_red_eye_outlined