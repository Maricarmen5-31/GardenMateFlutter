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
      // Let's set the message limit to 4
      // It's not featching the latest 4 messages
      // Right now there is no simple way to do that, but I hope soon Amplify fix that
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

  Future<Either<String, List<Sensor>>> getLatestSensors() async {
    const graphQLDocument = '''query GetLatestSensors {
            sensorsByDate(type: "Sensor" sortDirection: DESC limit: 4) {
              items {
                id
                humidity
                temperature
                createdAt
              }
            }
          }''';

    try {
      final response = await Amplify.API
          .query(request: GraphQLRequest<String>(document: graphQLDocument))
          .response;

      if (response.data != null) {
        Map<String, dynamic> data = json.decode(response.data!);
        List iteams = data['sensorsByDate']['items'];
        List<Sensor> sensors =
            iteams.map((sensor) => Sensor.fromJson(sensor)).toList();
        return right(sensors);
      }
      return right([]);
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
}
