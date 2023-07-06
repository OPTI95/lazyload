import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazyload/Login/RememberPassword/remember_password_code_widget.dart';
import 'package:lazyload/cubit/login_cubit.dart';
import 'package:lazyload/helpers/constans.dart';

class RememberPasswordEmailWidget extends StatelessWidget {
  var emailContoller = new MaskedTextController(
    mask: '#################',
    translator: {"#": RegExp(r"[a-z0-9]")},
  );
  RememberPasswordEmailWidget({Key? key}) : super(key: key);

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
                  height: 50,
                ),
                const ImageForgetPasswordWidget(),
                EmailTextFieldWidget(
                  emailContoller: emailContoller,
                ),
                NextButtonWidget(
                  emailContoller: emailContoller,
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

class ImageForgetPasswordWidget extends StatelessWidget {
  const ImageForgetPasswordWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Img.forgotPassword,
      height: 235,
      width: 235,
    );
  }
}

class NextButtonWidget extends StatelessWidget {
  const NextButtonWidget(
      {Key? key, required MaskedTextController emailContoller})
      : _emailcontroller = emailContoller;

  final MaskedTextController _emailcontroller;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final check =
            await context.read<LoginCubit>().checkEmail(_emailcontroller);
        if(check != null){
            context.read<LoginCubit>().sendEmail();
             Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RememberPasswordCodeWidget()));
         } else{
           ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  backgroundColor: Colors.amber,
                                  content: Text('Такой адрес не существует'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
         };
      },
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(150, 35))),
      child: const Text(
        "Продолжить",
        style: TextStyle(fontSize: 17),
      ),
    );
  }
}

class EmailTextFieldWidget extends StatelessWidget {
  EmailTextFieldWidget({Key? key, required MaskedTextController emailContoller})
      : _emailcontroller = emailContoller;

  final _emailcontroller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25, bottom: 30, top: 30),
      child: TextField(
        controller: _emailcontroller,
        decoration: InputDecoration(
            labelText: "Email",
            suffixIcon: Icon(Icons.email),
            suffixText: "@gmail.com"),
        cursorHeight: 25,
      ),
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
