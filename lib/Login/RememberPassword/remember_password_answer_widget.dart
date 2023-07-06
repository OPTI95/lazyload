import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazyload/Login/RememberPassword/remember_new_password_widget.dart';

class RememberPasswordAnswerWidget extends StatelessWidget {
  const RememberPasswordAnswerWidget({Key? key}) : super(key: key);

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
                  const TextQuestionWidget(),
                  const SizedBox(
                    height: 30,
                  ),
                  const TextFieldWidget(),
                  const SizedBox(
                    height: 50,
                  ),
                  const ButtonsWidget()
                ]),
          ],
        ),
      ),
    );
  }
}

class ButtonsWidget extends StatelessWidget {
  const ButtonsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      
      children: [
        ElevatedButton(onPressed: (){}, child: const Text("Вернуться")),
        ElevatedButton(onPressed: (){
Navigator.push(
            context,
            MaterialPageRoute(
                // builder: (context) => const RememberPasswordWidget(
                //     mainText: WelcomeTextWidget(padding: 70,))),
                builder: (context) =>  NewPasswordWidget()));

        }, child: const Text("Продолжить"))
      ],
    );
  }
}

class TextQuestionWidget extends StatelessWidget {
  const TextQuestionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Flexible(
            child: Text("Какой ваш любимый исполнитель?",style: TextStyle(fontSize: 15),)));
  }
}

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      // ignore: unnecessary_const
      child: const TextField(
        decoration: InputDecoration(labelText: "Ответ"),
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
