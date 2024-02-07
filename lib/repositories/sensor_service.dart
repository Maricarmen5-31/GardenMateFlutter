import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:garden_mate/models/ModelProvider.dart';

Future<void> createSensor(Sensor sensor) async {
  try {
    final request = ModelMutations.create(sensor);
    final response = await Amplify.API.mutate(request: request).response;

    final createdSensor = response.data;
    if (createdSensor == null) {
      safePrint('errors: ${response.errors}');
      return;
    }
    safePrint('Mutation result: ${createdSensor.id}');
  } on ApiException catch (e) {
    safePrint('Mutation failed: $e');
  }

  Future<List<Sensor?>> queryListItems() async {
    try {
      final request = ModelQueries.list(Sensor.classType);
      final response = await Amplify.API.query(request: request).response;

      final items = response.data?.items;
      if (items == null) {
        safePrint('errors: ${response.errors}');
        return <Sensor?>[];
      }
      return items;
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }
    return <Sensor?>[];
  }
}
