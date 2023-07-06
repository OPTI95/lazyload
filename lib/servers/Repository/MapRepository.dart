import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazyload/cubit/map_cubit.dart';
import 'package:lazyload/servers/Repository/CartRepository.dart';
import 'package:lazyload/servers/Repository/Presenter/CartPresenter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../helpers/constans.dart';

class MapRepository {
  final Dio _dio = Dio();

 
  Future<List<PlacemarkMapObject>> getListMapObject(
      BuildContext context) async {
    try {
      final response = await _dio.get(ApiLink.apiAddres + "restaraunts");
      final List placemarkMapObject = response.data;
      return placemarkMapObject.map((e) {
        Map<String, dynamic> json = e;
        return PlacemarkMapObject(
          onTap: (mapObject, point) async {
            final scaffold = Scaffold.maybeOf(context);
            if (scaffold != null) {
              context.read<MapCubit>().bottomSheetController =
                  Scaffold.of(context).showBottomSheet(
                      backgroundColor: Colors.transparent, (context) {
                return Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      )),
                  height: 250,
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: 60,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          json['nameRestaraunts'].toString(),
                          softWrap: true,
                          maxLines: 2,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Адрес: ${json['addressRestaraunts'].toString()}",
                            softWrap: true,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87)),
                        SizedBox(
                          height: 10,
                        ),
                        (DateTime.now().hour >= 8 && DateTime.now().hour < 23)
                            ? Text(
                                "Открыто до 23:00",
                                style: TextStyle(color: Colors.green),
                              )
                            : Text(
                                "Закрыто до 8:00",
                                style: TextStyle(color: Colors.red),
                              ),
                        Spacer(),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                    bool save = await CartPresenter(CartRepository(sharedPreferences)).saveRestaraunt(
                                        json['nameRestaraunts']);
                                    bool save2 = await CartPresenter(CartRepository(sharedPreferences)).saveAddressRestaraunt(
                                        json['addressRestaraunts']);
                                    if (save == true && save2 == true) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              Text('Ресторан выбран'),
                                              Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              ),
                                            ],
                                          ),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                      try {
                                        await Future.delayed(
                                            Duration(seconds: 2));
                                        context
                                            .read<MapCubit>()
                                            .bottomSheetController
                                            ?.close();
                                      } catch (e) {}
                                    }
                                  },
                                  child: Text(
                                    "Выбрать ресторан",
                                    style: TextStyle(fontSize: 16),
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
            }
            ;
          },
          mapId: MapObjectId(json['idRestaraunts'].toString()),
          opacity: 1,
          point:
              Point(latitude: json['latitude'], longitude: json['longitude']),
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage(Img.burgerImage),
              scale: 0.2,
            ),
          ),
        );
      }).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
