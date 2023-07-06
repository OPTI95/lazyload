import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../cubit/map_cubit.dart';
import '../../helpers/constans.dart';

class MapWidget extends StatefulWidget {
  MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  void initState() {
    context.read<MapCubit>().getMapObjectList(context);
    super.initState();
  }

  late YandexMapController _controller;
  var mapControllerCompleter = Completer<YandexMapController>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(builder: (context, state) {
      return Scaffold(
          backgroundColor:
              Colors.transparent, // задаем прозрачный фон для Scaffold
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () async {
                    await context.read<MapCubit>().getMapObjectList(context);
                  },
                  icon: Icon(Icons.refresh)),
              IconButton(
                onPressed: (() async {
                  Position position = await context.read<MapCubit>().determinePosition();
                  PlacemarkMapObject placemark = PlacemarkMapObject(
                      opacity: 1,
                      mapId: MapObjectId("geo"),
                      point: Point(
                          latitude: position.latitude,
                          longitude: position.longitude),
                      icon: PlacemarkIcon.single(PlacemarkIconStyle(
                          image: BitmapDescriptor.fromAssetImage(
                              Img.locationImage),
                          scale: 0.2)));
                  await context.read<MapCubit>().addMapObject(placemark);
                  if (mapControllerCompleter.isCompleted) {
                    await (await mapControllerCompleter.future).moveCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                            target: Point(
                                latitude: position.latitude,
                                longitude: position.longitude))));
                  }
                  // if (!mapControllerCompleter.isCompleted) {
                  //     mapControllerCompleter.complete(_controller);
                  //   } else {
                  //     mapControllerCompleter = Completer<YandexMapController>();
                  //     mapControllerCompleter.complete(_controller);
                  //   }
                  // await context.read<MapCubit>().geo(mapControllerCompleter);
                }),
                icon: Icon(Icons.gps_fixed),
              ),
            ],
          ),
          body: state is MapLoadedMapObjectsState
              ? YandexMap(
                  onMapCreated: (controller) async {
                    _controller = controller;
                    if (!mapControllerCompleter.isCompleted) {
                      mapControllerCompleter.complete(_controller);
                    } else {
                      mapControllerCompleter = Completer<YandexMapController>();
                      mapControllerCompleter.complete(_controller);
                    }
                    await context
                        .read<MapCubit>()
                        .setMapController(mapControllerCompleter);
                  },
                  mapObjects: state.placemarkMapObject,
                )
              : state is MapLoadingMapObjectsState
                  ? Center(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (_, index) {
                            context.read<MapCubit>().getMapObjectList(context);
                            return Center(child: CircularProgressIndicator());
                          }),
                    )
                  : Center(child: CircularProgressIndicator()));
    });
  }
}
