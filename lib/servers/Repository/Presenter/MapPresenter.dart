import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../MapRepository.dart';

class MapPresenter {
  final MapRepository mapRepository;
  final BuildContext context;
  MapPresenter(this.mapRepository, this.context);
  Future<List<PlacemarkMapObject>> getFoodList() async {
    try {
      return await mapRepository.getListMapObject(context);
    } catch (e) {
        throw Exception("Возникла ошибка ${e.toString()}");
    }
  }

 
}
