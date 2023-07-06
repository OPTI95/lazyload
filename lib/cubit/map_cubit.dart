import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lazyload/servers/Repository/MapRepository.dart';
import 'package:lazyload/servers/Repository/Presenter/MapPresenter.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';

import '../helpers/constans.dart';
part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());
  List<PlacemarkMapObject> listMapsObject = [];
    PersistentBottomSheetController? bottomSheetController;

  Future<void> setMapController(
      Completer<YandexMapController> controller) async {
      await (await controller.future).moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: Point(latitude: 55.75222, longitude: 37.61556), zoom: 13)));
  }

  Future<void> addMapObject(PlacemarkMapObject mapObject) async {
    try {
      PlacemarkMapObject? mapObject2 = listMapsObject
          .where((element) => element.mapId == mapObject.mapId)
          .first;
      listMapsObject.remove(mapObject2);
    } catch (e) {
      listMapsObject.add(mapObject);
    }
    emit(MapLoadedMapObjectsState(listMapsObject));
  }

  Future<void> getMapObjectList(
    BuildContext context,
  ) async {
    emit(MapLoadingMapObjectsState());
    MapPresenter _presenter = MapPresenter(MapRepository(), context);
    listMapsObject = await _presenter.getFoodList();
    emit(MapLoadedMapObjectsState(listMapsObject));
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.requestPermission();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(MapGetErrorGeoPositionState(
            "В разрешениях на определение местоположения отказано"));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(MapGetErrorGeoPositionState(
          "В разрешениях на определение местоположения постоянно отказано, мы не можем запрашивать разрешения"));
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
  }
}
