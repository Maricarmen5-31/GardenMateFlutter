import 'package:amplify_api/amplify_api.dart';
import 'package:garden_mate/models/Sensor.dart';
import 'package:garden_mate/repositories/sensor_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class SensorProvider with ChangeNotifier {
  final _sensorRepository = SensorRepository();

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
      (error) {
        _errorMessage = error;
        notifyListeners();
      },
      (sensors) {
        _sensors = sensors;
        notifyListeners();
      },
    );
    _setIsLoading(false);
  }

  Stream<GraphQLResponse<Sensor>> getSensorStream() {
    return _sensorRepository.subscribeToSensors();
  }

  void addSensor(Sensor sensor) {
    _sensors.insert(0, sensor);
    notifyListeners();
  }
}
