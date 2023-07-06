import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazyload/Login/RememberPassword/remember_password_code_widget.dart';
import '../Login/RememberPassword/remember_password_answer_widget.dart';
import '../Login/RememberPassword/remember_password_email_widget.dart';

class SwitchResetPasswordWidgett extends StatelessWidget {
  const SwitchResetPasswordWidgett({Key? key}) : super(key: key);

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
                  const WelcomeTextWidget(),
                  const Text(
                    "Сброс пароля",
                    style: TextStyle(fontSize: 25),
                  ),
                  const DividerWidget(),
                  const SizedBox(
                    height: 25,
                  ),
                  const TextWidget(),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 200,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ButtonToEmailWidget(
                          text: "Продолжить с почтой",
                          iconData: Icons.email_outlined,
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                       RememberPasswordEmailWidget())),
                        ),
                        ButtonToEmailWidget(
                          text: "Продолжить с телефона",
                          iconData: Icons.smartphone_outlined,
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                       RememberPasswordCodeWidget())),
                        ),
                        ButtonToEmailWidget(
                          text: "Продолжить с секретным вопросом",
                          iconData: Icons.question_answer_outlined,
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RememberPasswordAnswerWidget())),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}

@immutable
// ignore: must_be_immutable
class ButtonToEmailWidget extends StatefulWidget {
  String text;
  final IconData iconData;
  final Function() onTap;
  ButtonToEmailWidget(
      {Key? key, this.text = "", required this.iconData, required this.onTap})
      : super(key: key);

  @override
  State<ButtonToEmailWidget> createState() => _ButtonToEmailWidgetState();
}

class _ButtonToEmailWidgetState extends State<ButtonToEmailWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
          onPressed: () => widget.onTap(),
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(10, 35))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(widget.iconData),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(widget.text),
              )
            ],
          )),
    );
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
          "Выберите метод с помощью которого вы хотите восстановить пароль."),
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
            text:  TextSpan(
              text: "OPTI",
              style: GoogleFonts.abrilFatface(
                      fontSize: 40, color: Colors.black54),
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
