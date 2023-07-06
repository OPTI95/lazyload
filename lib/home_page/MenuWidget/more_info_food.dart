import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazyload/cubit/cart_cubit.dart';
import 'package:lazyload/cubit/food_cubit.dart';
import '../../servers/Repository/FoodRepository.dart';

class MoreInfoFoodWidget extends StatelessWidget {
  const MoreInfoFoodWidget({super.key, required this.food});
  final Food food;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 20),
          Container(
              padding: EdgeInsets.all(4),
              alignment: Alignment.topLeft,
              child: IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios))),
          SizedBox(
            height: 40,
          ),
          Image.network(
            food.imageFood!,
            width: 200,
            height: 200,
          ),
           SizedBox(height: 20,),
          Center(
            child: Text(food.nameFood,
                style: GoogleFonts.abhayaLibre(
                    fontWeight: FontWeight.bold, fontSize: 24)),
          ),
          SizedBox(height: 20,),
          Center(
            child: Text("Данные блюда: ",
                style: GoogleFonts.abhayaLibre(
                    fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          Divider(
            indent: 10,
            endIndent: 10,
            thickness: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    food.weightFood.toString(),
                    style: GoogleFonts.abhayaLibre(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text("грамм",
                      style: GoogleFonts.abhayaLibre(
                          fontWeight: FontWeight.normal, fontSize: 15))
                ],
              ),
              Column(
                children: [
                  Text(
                    food.calFood.toString(),
                    style: GoogleFonts.abhayaLibre(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text("ккал",
                      style: GoogleFonts.abhayaLibre(
                          fontWeight: FontWeight.normal, fontSize: 15))
                ],
              ),
              Column(
                children: [
                  Text(
                    food.proteins.toString(),
                    style: GoogleFonts.abhayaLibre(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text("белки",
                      style: GoogleFonts.abhayaLibre(
                          fontWeight: FontWeight.normal, fontSize: 15))
                ],
              ),
              Column(
                children: [
                  Text(
                    food.fats.toString(),
                    style: GoogleFonts.abhayaLibre(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text("жиры",
                      style: GoogleFonts.abhayaLibre(
                          fontWeight: FontWeight.normal, fontSize: 15))
                ],
              ),
              Column(
                children: [
                  Text(
                    food.carbohydrates.toString(),
                    style: GoogleFonts.abhayaLibre(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text("углеводы",
                      style: GoogleFonts.abhayaLibre(
                          fontWeight: FontWeight.normal, fontSize: 15))
                ],
              )
            ],
          ),
          Divider(
            indent: 10,
            endIndent: 10,
            thickness: 2,
          ),
          Center(
            child: Text("Описание:",
                style: GoogleFonts.abhayaLibre(
                    fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              food.descriptionFood,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          food.ingredientsFood != ""
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Состав: ${food.ingredientsFood.toString()}", style: TextStyle(color: Colors.black87),),
                    ),
                  ],
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () async{
                           await context.read<CartCubit>().setCartList(food,false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Добавил в корзину'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                        },
                        child: Text(
                            "В корзину " + food.priceFood.toString() + " ₽"))),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
