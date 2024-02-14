import 'dart:async';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:garden_mate/constants.dart';
import 'package:garden_mate/models/Sensor.dart';
import 'package:garden_mate/models/controlPlant.dart';
import 'package:garden_mate/providers/sensor_provider.dart';
import 'package:garden_mate/screens/record_screen.dart';
import 'package:garden_mate/shared/extensions.dart';
import 'package:garden_mate/utils/constants.dart';
import 'package:garden_mate/widgets/record_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:garden_mate/repositories/sensor_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// _HomeScreenState es una clase que se encargara de manejar el estado de la pantalla de inicio
class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription _sensorSubscription;
  late StreamSubscription _sensorUpdateSubscription;
  late StreamSubscription _sensorDeleteSubscription;
  @override
  void initState() {
    getMessages();
    super.initState();
  }

  void getMessages() {
    final messageProvider = context.read<SensorProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sensorSubscription = messageProvider.subscribeToSensorStream().listen(
        (response) {
          if (response.data != null) {
            messageProvider.addSensor(response.data!);
          } else if (response.hasErrors) {
            context.showError(response.errors.first.message);
          }
        },
      );

      _sensorUpdateSubscription = messageProvider.updateToSensorStream().listen(
        (response) {
          if (response.data != null) {
            messageProvider.updateSensor(response.data!);
          } else if (response.hasErrors) {
            context.showError(response.errors.first.message);
          }
        },
      );

      _sensorDeleteSubscription = messageProvider.deleteToSensorStream().listen(
        (response) {
          if (response.data != null) {
            messageProvider.deleteSensor(response.data!);
          } else if (response.hasErrors) {
            context.showError(response.errors.first.message);
          }
        },
      );
    });
  }

  @override
  void dispose() {
    _sensorSubscription.cancel();
    _sensorUpdateSubscription.cancel();
    _sensorDeleteSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<ControlPlant> plantList = ControlPlant.plantList;

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  width: size.width * .9,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor.withOpacity(.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.black54.withOpacity(.6),
                      ),
                      const Expanded(
                          child: TextField(
                        showCursor: false,
                        decoration: InputDecoration(
                          hintText: 'Buscar planta',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      )),
                      Icon(
                        Icons.mic,
                        color: Colors.black54.withOpacity(.6),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, bottom: 20, top: 20),
            child: const Text(
              'Dato tiempo real',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          Center(
            child: Container(
              padding:
                  EdgeInsets.all(10), // Agrega padding dentro del Container
              decoration: BoxDecoration(
                color:
                    Constants.primaryColor.withOpacity(.15), // Cambia el color de fondo a azul claro
                borderRadius:
                    BorderRadius.circular(10), // Agrega bordes redondeados
                boxShadow: [
                  // Agrega sombra
                  BoxShadow(
                    color: Colors.white.withOpacity(.15),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Consumer<SensorProvider>(
                builder: (context, provider, child) {
                  if (provider.sensors.isEmpty) {
                    return Text('No hay datos de sensores disponibles');
                  }
                  return Column(
                    children: [
                      Text(
                        'Temperatura: ${provider.sensors.first.temperature}°C',
                        style: TextStyle(
                          color:
                              Colors.black, // Cambia el color del texto a negro
                          fontWeight:
                              FontWeight.bold, // Hace que el texto sea negrita
                        ),
                      ),
                      Text(
                        'Humedad: ${provider.sensors.first.humidity}%',
                        style: TextStyle(
                          color:
                              Colors.black, // Cambia el color del texto a gris
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, bottom: 20, top: 20),
            child: const Text(
              'Lista de datos historicos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          Container(
            height: 200, // Define una altura para el Container
            child: Consumer<SensorProvider>(
              builder: (context, provider, child) {
                safePrint(
                    'Cantidad de sensores: ${provider.sensors.length}'); // Imprime la cantidad de sensores

                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (provider.errorMessage != null) {
                  return Center(
                    child: Text(provider.errorMessage!),
                  );
                }
                return ListView.builder(
                  itemCount: provider.sensors.length,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.all(
                        10), // Agrega margen alrededor de cada Container
                    padding: EdgeInsets.all(
                        10), // Agrega padding dentro de cada Container
                    decoration: BoxDecoration(
                      color: Constants.primaryColor.withOpacity(.15), // Cambia el color de fondo a azul claro
                      borderRadius: BorderRadius.circular(
                          10), // Agrega bordes redondeados
                      boxShadow: [
                        // Agrega sombra
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Center(
                        // Centra el título
                        child: Text(
                          'Temperatura: ${provider.sensors[index].temperature}°C',
                          style: TextStyle(
                            color: Colors
                                .black, // Cambia el color del texto a negro
                            fontWeight: FontWeight
                                .bold, // Hace que el texto sea negrita
                          ),
                        ),
                      ),
                      subtitle: Center(
                        // Centra el subtítulo
                        child: Text(
                          'Humedad: ${provider.sensors[index].humidity}%',
                          style: TextStyle(
                            color: Colors
                                .blueGrey, // Cambia el color del texto a gris
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, bottom: 20, top: 20),
            child: const Text(
              'Lista de Registros',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: size.height * .75,
            child: ListView.builder(
                itemCount: plantList.length,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: RecordScreen(
                                    plantId: plantList[index].plantId),
                                type: PageTransitionType.bottomToTop));
                      },
                      child: RecordWidget(index: index, plantList: plantList));
                }),
          ),
        ],
      ),
    ));
  }
}
