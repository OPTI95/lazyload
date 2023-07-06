import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazyload/Login/login_widget.dart';

import '../helpers/constans.dart';

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<String> slogan = ["Когда хочется чего-нибудь вкусненького!","Настоящий русский fastfood",
    "Твоя любимая еда","Друг познается в еде","Готовим от всего сердца","Без добавки не обойтись","Иногда можно","Удовольствие от каждого укуса","Полный восторг",
    "Подкрепление прибыло!","Всегда свежее","Весело и вкусно","Поедем поедим","Не бывает слишком много мяса"];
    return Scaffold(
        body: Center(
      child: Container(
        width: 400,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ImageBurgerWidget(),
            RichText(
                textDirection: TextDirection.ltr,
                text: TextSpan(
                  text: "OPTI",
                  style: GoogleFonts.abrilFatface(
                      fontSize: 40, color: Colors.black54),
                  children: const <TextSpan>[
                    TextSpan(
                        text: "FOOD",
                        style:
                            TextStyle(color: Color.fromARGB(248, 220, 171, 8))),
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
              child: AnimatedTextKit(repeatForever: true, animatedTexts: [
                for (int i = 1; i < slogan.length; i++)
                animatedText(slogan[i].toString()),
              ]),
            ),
            const SizedBox(
              height: 120,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, _createRoute());
                },
                child: const Text(
                  "Погнали!",
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
    ));
  }

  FadeAnimatedText animatedText(String text) {
    return FadeAnimatedText(text,
                  textStyle: GoogleFonts.aclonica());
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const LoginWidget(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const curve = Curves.ease;
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );
      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}

class ImageBurgerWidget extends StatelessWidget {
  const ImageBurgerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Img.burgerImage,
      height: 235,
      width: 235,
    );
  }
}
