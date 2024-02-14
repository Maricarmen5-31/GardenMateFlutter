import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:garden_mate/models/Sensor.dart';
import 'package:garden_mate/repositories/sensor_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
// revisa si esa bien la importacion de amplify
import 'package:amplify_flutter/amplify_flutter.dart';

class SensorProvider with ChangeNotifier {
  final _sensorRepository = SensorRepository();
  late StreamSubscription<GraphQLResponse<Sensor>> _sensorSubscription;

  bool _isLoading = false;
  List<Sensor> _sensors = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<Sensor> get sensors => _sensors;
  String? get errorMessage => _errorMessage;

  void _setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<Either<String, Sensor?>> sendSensor(Sensor sensor) {
    return _sensorRepository.sendSensor(sensor);
  }

  void getSensors() async {
    _setIsLoading(true);
    final sensorResponse = await _sensorRepository.getLatestSensors();

    sensorResponse.fold(
      (error) => _errorMessage = error,
      (sensors) => _sensors = sensors,
    );

    _setIsLoading(false);
    notifyListeners();
  }

  // stream de sensores que se suscribira a los cambios o creacion o borrado de los sensores
  Stream<GraphQLResponse<Sensor>> subscribeToSensorStream() {
    return _sensorRepository.subscribeToSensorStream();
  }

  Stream<GraphQLResponse<Sensor>> updateToSensorStream() {
    return _sensorRepository.updateToSensorStream();
  }

  Stream<GraphQLResponse<Sensor>> deleteToSensorStream() {
    return _sensorRepository.deleteToSensorStream();
  }

  // startListeningToSensors es una funcion que se encargara de escuchar los cambios en los sensores
  void startListeningToSensors() {
    _sensorSubscription = subscribeToSensorStream().listen((event) {
      final sensor = event.data;
      if (sensor != null) {
        addSensor(sensor);
      }
    });
  }

  // deleteSensor es una funcion que se encargara de eliminar un sensor de la lista de sensores
  void deleteSensor(Sensor sensor) {
    _sensors.removeWhere((s) => s.id == sensor.id);
    notifyListeners();
  }

  void addSensor(Sensor sensor) async {
    _sensors.insert(0, sensor);
    safePrint("TAMANO${_sensors.length}");
    while (_sensors.length > 10) {
      Sensor sensorToRemove = _sensors.removeLast();
      await _sensorRepository.deleteSensor(sensorToRemove.id);
    }

    notifyListeners();
  }

  // updateSensor es una funcion que se encargara de actualizar un sensor de la lista de sensores
  void updateSensor(Sensor sensor) {
    _sensors.removeWhere((element) => element.id == sensor.id);
    _sensors.insert(0, sensor);
    notifyListeners();
  }
}
