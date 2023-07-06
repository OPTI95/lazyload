import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazyload/Login/RememberPassword/remember_password_code_widget.dart';
import 'package:lazyload/RegistrationAccount/image_profile.dart';
import 'package:lazyload/RegistrationAccount/send_code.dart';
import 'package:lazyload/cubit/login_cubit.dart';
import 'package:lazyload/servers/Repository/UserRepository.dart';

class ProfileInformationWidget extends StatelessWidget {
  var secondNameContoller =
      new MaskedTextController(mask: "№№№№№№№№№№№№№№№",translator: {"№": RegExp(r"[А-я]") });
  var firstNameContoller =
      new MaskedTextController(mask: "№№№№№№№№№№№№№№№", translator: {"№": RegExp(r"[А-я]")});
  var emailContoller = new MaskedTextController(
    mask: '#################',
    translator: {"#": RegExp(r"[a-z0-9]")},
  );
  var passwordContoller = new MaskedTextController(
    mask: '#################',
    translator: {"#": RegExp(r"[a-z0-9!#$%&? ]")},
  );
  var numberPhoneContoller = new MaskedTextController(
    mask: '+# (###) ###-##-##',
    translator: {"#": RegExp(r'[0-9]')},
  );
  ProfileInformationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const WelcomeTextWidget(),
                  const CircleWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Информация о профиле",
                    style: const TextStyle(fontSize: 24),
                  ),
                  const DividerWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        TextField(
                          controller: secondNameContoller,
                          decoration:
                              const InputDecoration(label: Text("Фамилия")),
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: firstNameContoller,
                          decoration: const InputDecoration(label: Text("Имя")),
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        
                        TextField(
                          controller: emailContoller,
                          decoration: const InputDecoration(
                              label: Text("Почта"), suffixText: "@gmail.com"),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: passwordContoller,
                          decoration: InputDecoration(label: Text("Пароль")),
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: numberPhoneContoller,
                          decoration: const InputDecoration(
                            label: Text("Номер телефона"),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Вернуться")),
                      ElevatedButton(
                          onPressed: () {
                            if (firstNameContoller.text.length >= 2 &&
                                secondNameContoller.text.length >= 2 &&
                                passwordContoller.text.length >= 8 &&
                                emailContoller.text.length >= 2 &&
                                numberPhoneContoller.text.length >=11) {
                              context.read<LoginCubit>().addInfoUser(
                                  secondNameContoller,
                                  firstNameContoller,
                                  emailContoller,
                                  passwordContoller,
                                  numberPhoneContoller);
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const ImageProfileWidget(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  backgroundColor: Colors.amber,
                                  content: Text('Не все поля заполнены'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                          child: const Text("Продолжить "))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
              borderRadius: BorderRadius.circular(90), color: Colors.grey[400]),
          width: 8,
          height: 8,
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90), color: Colors.grey[400]),
          width: 8,
          height: 8,
        ),
      ],
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
                    style: TextStyle(
                        color: const Color.fromARGB(248, 220, 171, 8))),
                const TextSpan(
                    text: "🍔",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ],
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

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
