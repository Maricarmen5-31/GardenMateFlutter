import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:garden_mate/models/Sensor.dart';
import 'package:dartz/dartz.dart';

class SensorRepository {
  Future<Either<String, Sensor?>> sendSensor(Sensor sensor) async {
    try {
      final request = ModelMutations.create(sensor);
      final response = await Amplify.API.mutate(request: request).response;
      return right(response.data);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  Future<Either<String, List<Sensor>>> getSensors() async {
    try {
      final request = ModelQueries.list(Sensor.classType, limit: 20);
      final response = await Amplify.API.query(request: request).response;
      final sensors = response.data?.items.whereType<Sensor>().toList();
      if (sensors != null) {
        sensors.sort((a, b) => b.createdAt?.compareTo(a.createdAt!) ?? 0);
      }

      return right(sensors ?? []);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  // agrega una funcion que obtenga los datos de los sensores
  Future<Either<String, List<Sensor>>> getLatestSensors() async {
    try {
      final request = ModelQueries.list(Sensor.classType, limit: 20);
      final response = await Amplify.API.query(request: request).response;
      final sensors = response.data?.items.whereType<Sensor>().toList();
      if (sensors != null) {
        sensors.sort((a, b) => b.createdAt?.compareTo(a.createdAt!) ?? 0);
      }

      return right(sensors ?? []);
    } on ApiException catch (e) {
      return left(e.message);
    }
  }

  Stream<GraphQLResponse<Sensor>> subscribeToSensors() {
    final subscriptionRequest = ModelSubscriptions.onCreate(Sensor.classType);
    final operation = Amplify.API.subscribe(
      subscriptionRequest,
      onEstablished: () => safePrint("Subscription established"),
    );

    return operation;
  }

  // stream de sensores
  Stream<GraphQLResponse<Sensor>> subscribeToSensorStream() {
    final subscriptionRequest = ModelSubscriptions.onCreate(Sensor.classType);
    final operation = Amplify.API.subscribe(
      subscriptionRequest,
      onEstablished: () => safePrint("Subscription established"),
    );

    return operation;
  }

  // stream de sensores
  Stream<GraphQLResponse<Sensor>> deleteToSensorStream() {
    final subscriptionRequest = ModelSubscriptions.onDelete(Sensor.classType);
    final operation = Amplify.API.subscribe(
      subscriptionRequest,
      onEstablished: () => safePrint("Delete established"),
    );

    return operation;
  }

  // stream de sensores
  Stream<GraphQLResponse<Sensor>> updateToSensorStream() {
    final subscriptionRequest = ModelSubscriptions.onUpdate(Sensor.classType);
    final operation = Amplify.API.subscribe(
      subscriptionRequest,
      onEstablished: () => safePrint("Update established"),
    );

    return operation;
  }

  Future<void> deleteSensor(String sensorId) async {
    // Crear un SensorEntr con el ID del sensor que quieres eliminar
    final sensor = Sensor(id: sensorId);

    // Crear una solicitud de eliminación para el sensor
    final request = ModelMutations.delete<Sensor>(sensor);

    // Realizar la operación de eliminación
    final response = await Amplify.API.mutate(request: request);

    safePrint('Delete response: $response');

    // Actualizar la lista de sensores
  }
}
