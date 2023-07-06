part of 'map_cubit.dart';

@immutable
abstract class MapState {}

class MapInitial extends MapState {}

class MapLoadingGeoPositionState extends MapState {}
class MapLoadingMapObjectsState extends MapState {}
class MapLoadedMapObjectsState extends MapState {
  final List<PlacemarkMapObject> placemarkMapObject;

  MapLoadedMapObjectsState(this.placemarkMapObject);
}


class MapLoadedGeoPositionState extends MapState {
  final PlacemarkMapObject placemarkMapObject;

  MapLoadedGeoPositionState(this.placemarkMapObject);
}

class MapGetErrorGeoPositionState extends MapState {
  final String error;

  MapGetErrorGeoPositionState(this.error);
}


