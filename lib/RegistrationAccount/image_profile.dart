import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lazyload/RegistrationAccount/send_code.dart';
import 'package:lazyload/cubit/login_cubit.dart';
import 'package:lazyload/servers/Repository/ImgurRepository.dart';

class ImageProfileWidget extends StatefulWidget {
  const ImageProfileWidget({Key? key}) : super(key: key);

  @override
  State<ImageProfileWidget> createState() => _ImageProfileWidgetState();
}

class _ImageProfileWidgetState extends State<ImageProfileWidget> {
  File? _image;
  String _imagePath = "";
  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      _imagePath = image.path;
      setState(() {
        _image = img;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Scaffold(
            body: Center(
                child: state is LoginEmptyState
                    ? Column(children: [
                        const WelcomeTextWidget(),
                        const CircleWidget(),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Информация о профиле",
                          style: TextStyle(fontSize: 24),
                        ),
                        const DividerWidget(),
                        const SizedBox(
                          height: 50,
                        ),
                        const Text(
                          "Выберите изображение",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () => _pickImage(ImageSource.gallery),
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(33),
                                border:
                                    Border.all(color: Colors.amber, width: 3)),
                            child: Container(
                              child: _image == null
                                  ? const Center(
                                      child:
                                          const Text("Изображение не выбрано"),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.file(
                                        FileImage(_image!).file,
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
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
                                onPressed: () async {
                                  if (_image != null) {
                                    await context
                                        .read<LoginCubit>()
                                        .uploadImage(_imagePath!);
                                    await context
                                        .read<LoginCubit>()
                                        .sendEmail();
                                  } else {
                                    context
                                        .read<LoginCubit
                                        
                                        >()
                                        .userReg
                                        .profileImageUser = null;
                                    await context
                                        .read<LoginCubit>()
                                        .sendEmail();
                                  }
                                  Navigator.push<void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const SendCodeWidget(),
                                    ),
                                  );
                                },
                                child: const Text("Продолжить")),
                          ],
                        )
                      ])
                    : CircularProgressIndicator()));
      },
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
                    style: const TextStyle(
                        color: Color.fromARGB(248, 220, 171, 8))),
                const TextSpan(
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
