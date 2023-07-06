
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazyload/cubit/cart_cubit.dart';
import 'package:lazyload/cubit/category_cubit.dart';
import 'package:lazyload/cubit/coupon_cubit.dart';
import 'package:lazyload/cubit/food_cubit.dart';
import 'package:lazyload/cubit/login_cubit.dart';
import 'package:lazyload/cubit/map_cubit.dart';
import 'package:lazyload/cubit/payment_cubit.dart';
import 'package:lazyload/home_page/CartWidget/PaymentWidget/payment_widget.dart';
import 'package:lazyload/servers/Repository/CouponRepository.dart';
import 'package:lazyload/servers/Repository/FoodRepository.dart';

import 'StartScreen/splash_screen.dart';
import 'home_page/DiscountWidget/discount_widget.dart';

void main() async{
  runApp(const MultiBlocProviders());
}

class MultiBlocProviders extends StatelessWidget {
  const MultiBlocProviders({super.key});

  @override
  Widget build(BuildContextcontext) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CartCubit(),
        ),
        BlocProvider(
          create: (context) => CategoryCubit(),
        ),
        BlocProvider(
          create: (context) => FoodCubit(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => MapCubit(),
        ),
        BlocProvider(
          create: (context) => PaymentCubit(),
        ),
         BlocProvider(
          create: (context) => CouponCubit(),
        ),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.amber,
          shadowColor: Colors.amberAccent,
          buttonTheme: const ButtonThemeData(buttonColor: Colors.pink),
          useMaterial3: false),
      home: SplashScreenWidget()
    );
  }
}

