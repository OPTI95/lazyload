import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazyload/Login/RememberPassword/remember_password_email_widget.dart';
import 'package:lazyload/RegistrationAccount/profile_information.dart';
import 'package:lazyload/cubit/login_cubit.dart';
import 'package:lazyload/helpers/constans.dart';
import 'package:lazyload/home_page/home.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    PersistentBottomSheetController? bottomSheetController;
    TextEditingController loginController = new TextEditingController();
    TextEditingController passwordController = new TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 22),
              child: RichText(
                  textDirection: TextDirection.ltr,
                  text: TextSpan(
                    text: "OPTI",
                    style: GoogleFonts.abrilFatface(
                        fontSize: 40, color: Colors.black54),
                    children: const <TextSpan>[
                      TextSpan(
                          text: "FOOD",
                          style: TextStyle(
                              color: Color.fromARGB(248, 220, 171, 8))),
                      TextSpan(
                          text: "🍔",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ],
                  ))),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 50),
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Column(
                  children: [
                    TextField(
                      controller: loginController,
                      decoration: state is LoginErrorState
                          ? InputDecoration(labelText: "Почта", errorText: "")
                          : InputDecoration(labelText: "Почта"),
                      cursorHeight: 25,
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: state is LoginErrorState
                          ? InputDecoration(
                              labelText: "Пароль",
                              errorText: "Неправильная почта или пароль!")
                          : InputDecoration(labelText: "Пароль"),
                      cursorHeight: 25,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                    )
                  ],
                );
              },
            ),
          ),
          BlocConsumer<LoginCubit, LoginState>(listener: (context, state) {
            if (state is LoginEmptyState) {
              FocusManager.instance.primaryFocus?.unfocus();
              bottomSheetController =
                  Scaffold.of(context).showBottomSheet((context) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Img.burgerGIFImage,
                                height: 100, width: 100),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Ищем вас...",
                              style: TextStyle(fontSize: 22),
                            ),
                          ],
                        ),
                      ));
            } else if (state is LoginLoadedState) {
              Navigator.push(context, createRoute());
              if (bottomSheetController != null) {
                bottomSheetController!.close();
              }
            } else if (state is LoginErrorState) {
              if (bottomSheetController != null) {
                bottomSheetController!.close();
              }
            }
          }, builder: (context, state) {
            return ElevatedButton(
                onPressed: () async {
                  final loginCubit = context.read<LoginCubit>();
                  await loginCubit.checkLoginAndPassword(
                      loginController.text, passwordController.text);
                },
                child: const Text(
                  "Войти",
                  style: TextStyle(fontSize: 20),
                ));
          }),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        // builder: (context) => const RememberPasswordWidget(
                        //     mainText: WelcomeTextWidget(padding: 70,))),
                        builder: (context) => RememberPasswordEmailWidget()));
              },
              child: const Text("Забыли пароль?",
                  style: TextStyle(color: Color.fromARGB(248, 220, 171, 8)))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("У вас нет аккаунта?"),
              TextButton(
                  onPressed: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            ProfileInformationWidget(),
                      ),
                    );
                  },
                  child: const Text("Создать",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      )))
            ],
          )
        ],
      ),
    );
  }
}

class ButtonConnectToGoogleWidget extends StatelessWidget {
  const ButtonConnectToGoogleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(1),
            backgroundColor: MaterialStateProperty.all(
                const Color.fromRGBO(248, 244, 220, 1)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            minimumSize: MaterialStateProperty.all(const Size(10, 50))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(SvgImg.googleIcon),
            const Text("  Connect with Google",
                style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}

class ButtonForgetPasswordWidget extends StatelessWidget {
  const ButtonForgetPasswordWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  // builder: (context) => const RememberPasswordWidget(
                  //     mainText: WelcomeTextWidget(padding: 70,))),
                  builder: (context) => RememberPasswordEmailWidget()));
        },
        child: const Text("Забыли пароль?",
            style: TextStyle(color: Color.fromARGB(248, 220, 171, 8))));
  }
}

class ButtonEnterWidget extends StatelessWidget {
  ButtonEnterWidget({
    Key? key,
    required this.loginController,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController loginController;
  final TextEditingController passwordController;
  @override
  Widget build(BuildContext context) {
    PersistentBottomSheetController? bottomSheetController;

    return BlocConsumer<LoginCubit, LoginState>(listener: (context, state) {
      if (state is LoginEmptyState) {
        FocusManager.instance.primaryFocus?.unfocus();
        bottomSheetController =
            Scaffold.of(context).showBottomSheet((context) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Img.burgerGIFImage, height: 100, width: 100),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Ищем вас...",
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                ));
      } else if (state is LoginLoadedState) {
        Navigator.push(context, createRoute());
        if (bottomSheetController != null) {
          bottomSheetController!.close();
        }
      } else if (state is LoginErrorState) {
        if (bottomSheetController != null) {
          bottomSheetController!.close();
        }
      }
    }, builder: (context, state) {
      return ElevatedButton(
          onPressed: () async {
            final loginCubit = context.read<LoginCubit>();
            await loginCubit.checkLoginAndPassword(
                loginController.text, passwordController.text);
          },
          child: const Text(
            "Войти",
            style: TextStyle(fontSize: 20),
          ));
    });
  }
}

Route createRoute() {
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

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget(
      {Key? key,
      required TextEditingController loginController,
      required TextEditingController passwordController})
      : _logincontroller = loginController,
        _passwordcontroller = passwordController;

  final _logincontroller, _passwordcontroller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 50),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            children: [
              TextField(
                controller: _logincontroller,
                decoration: state is LoginErrorState
                    ? InputDecoration(labelText: "Почта", errorText: "")
                    : InputDecoration(labelText: "Почта"),
                cursorHeight: 25,
              ),
              TextField(
                controller: _passwordcontroller,
                decoration: state is LoginErrorState
                    ? InputDecoration(
                        labelText: "Пароль",
                        errorText: "Неправильная почта или пароль!")
                    : InputDecoration(labelText: "Пароль"),
                cursorHeight: 25,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              )
            ],
          );
        },
      ),
    );
  }
}

class WelcomeTextWidget extends StatelessWidget {
  final double padding;
  const WelcomeTextWidget({
    Key? key,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: padding),
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

class DividerWidget extends StatelessWidget {
  const DividerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 30),
        child: const Divider(
          height: 1,
          indent: 100,
          endIndent: 100,
          thickness: 2,
        ));
  }
}

class QuestionButtonWidget extends StatelessWidget {
  const QuestionButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("У вас нет аккаунта?"),
        TextButton(
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => ProfileInformationWidget(),
                ),
              );
            },
            child: const Text("Создать",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                )))
      ],
    );
  }
}
