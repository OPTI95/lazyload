import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazyload/helpers/constans.dart';

class PickFavoriteFood extends StatefulWidget {
  const PickFavoriteFood({Key? key}) : super(key: key);

  @override
  State<PickFavoriteFood> createState() => _PickFavoriteFoodState();
}

class _PickFavoriteFoodState extends State<PickFavoriteFood> {
  List<Map<String, dynamic>> categori = [
    {
      'title': "Бургеры",
      'img': Img.burgerImage,
    },
    {
      'title': "Пицца",
      'img': Img.forgotPassword,
    },
    {
      'title': "Бургеры",
      'img': Img.burgerImage,
    },
    {
      'title': "Пицца",
      'img': Img.forgotPassword,
    },
    {
      'title': "Бургеры",
      'img': Img.burgerImage,
    },
    {
      'title': "Пицца",
      'img': Img.forgotPassword,
    },
    {
      'title': "Бургеры",
      'img': Img.burgerImage,
    },
    {
      'title': "Пицца",
      'img': Img.forgotPassword,
    },
    {
      'title': "Пицца",
      'img': Img.forgotPassword,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              const WelcomeTextWidget(),
              const CircleWidget(),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Выберите свои предпочтения",
                style: const TextStyle(fontSize: 24),
              ),
              const DividerWidget(),
              const SizedBox(
                height: 10,
              ),
              GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: categori.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) => CategoryCardWidget(
                  categori: categori,
                  index: index,
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
                      onPressed: () {}, child: const Text("Продолжить")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCardWidget extends StatefulWidget {
  final int index;
  const CategoryCardWidget({
    Key? key,
    required this.categori,
    required this.index,
  }) : super(key: key);

  final List<Map<String, dynamic>> categori;

  @override
  State<CategoryCardWidget> createState() => _CategoryCardWidgetState();
}

class _CategoryCardWidgetState extends State<CategoryCardWidget> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });
        },
        child: Container(
          color: isSelected ? Colors.amber[100] : Colors.white12,
          child: Column(
            children: [
              Image.asset(
                widget.categori[widget.index]["img"],
                width: 100,
                height: 100,
              ),
              Text(
                widget.categori[widget.index]['title'],
              ),
            ],
          ),
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
    return const Divider(
      thickness: 2,
      indent: 30,
      endIndent: 30,
      color: Colors.amber,
    );
  }
}
