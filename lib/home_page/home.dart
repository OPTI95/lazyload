import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazyload/helpers/constans.dart';
import 'package:lazyload/home_page/CartWidget/cart_widget.dart';
import '../cubit/map_cubit.dart';
import 'DiscountWidget/discount_widget.dart';
import 'MapWidget/map_widget.dart';
import 'MenuWidget/menu_widget.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});
  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int index = 0;
  double heightContainer = 0;
  List<BottomNavigationBarItem> bottomNavigationBarItem = [
    BottomNavigationBarItem(
        icon: ImageIcon(new AssetImage(Img.menuImage)), label: "Меню"),
    BottomNavigationBarItem(
        icon: ImageIcon(new AssetImage(Img.discountImage)), label: "Купоны"),
    BottomNavigationBarItem(
        icon: ImageIcon(new AssetImage(Img.locationImage)), label: "Рестораны"),
    BottomNavigationBarItem(
        icon: ImageIcon(new AssetImage(Img.cartImage)), label: "Корзина")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
        
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          onTap: (value) {
            if (index != value) {
              setState(() {
                try {
                  context.read<MapCubit>().bottomSheetController?.close();
                } catch (e) {}
                index = value;
              });
            }
          },
          currentIndex: index,
          showUnselectedLabels: true,
          iconSize: 25,
          
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: [
            bottomNavigationBarItem.elementAt(0),
            bottomNavigationBarItem.elementAt(1),
            bottomNavigationBarItem.elementAt(2),
            bottomNavigationBarItem.elementAt(3)
          ],
        ),
        body: index == 0
            ? MenuWidget()
            : (index == 1
                ? DiscountWidget()
                : (index == 2 ? MapWidget() : BottomSheetWidget())));
  }
}
