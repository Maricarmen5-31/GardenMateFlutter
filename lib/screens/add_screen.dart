import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:garden_mate/models/Sensor.dart';
import 'package:garden_mate/providers/sensor_provider.dart';
import 'package:garden_mate/repositories/sensor_repository.dart';
import 'package:garden_mate/shared/extensions.dart';
import 'package:garden_mate/utils/constants.dart';
import 'package:garden_mate/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _humidityController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool _isLoading = false;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Constants.primaryColor.withOpacity(.15),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            right: 20,
            left: 20,
            child: Container(
              width: size.width * .8,
              height: size.height * .8,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 200.0,
                        height: 200.0,
                        decoration: BoxDecoration(
                          color: Constants.primaryColor.withOpacity(.4),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: 160.0,
                          child: Image.asset('assets/images/plant-six.png'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Agregar sensor',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextfield(
                              obscureText: false,
                              controller: _humidityController,
                              hintText: 'Humedad',
                              icon: Icons.water,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, introduce la humedad';
                                }
                                return null;
                              },
                            ),
                            CustomTextfield(
                              obscureText: false,
                              controller: _temperatureController,
                              hintText: 'Temperatura',
                              icon: Icons.thermostat,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, introduce la temperatura';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: _isLoading
                                  ? null
                                  : () async {
                                      setState(() {
                                        _isLoading = true; // Comienza la carga
                                      });

                                      if (_formKey.currentState != null &&
                                          _formKey.currentState!.validate()) {
                                        String humidity =
                                            _humidityController.text;
                                        String temperature =
                                            _temperatureController.text;

                                        // Obtener los valores de los campos
                                        double parsedHumidity =
                                            double.parse(humidity);
                                        double parsedTemperature =
                                            double.parse(temperature);

                                        // Crear el sensor
                                        final sensor = Sensor(
                                          temperature: parsedTemperature,
                                          humidity: parsedHumidity,
                                        );

                                        // Instanciar SensorRepository
                                        SensorRepository sensorRepository =
                                            SensorRepository();

                                        // Agregar el sensor utilizando sendSensor
                                        await sensorRepository
                                            .sendSensor(sensor);

                                        // Limpiar los campos
                                        _humidityController.clear();
                                        _temperatureController.clear();

                                        // Mostrar un mensaje de éxito
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Sensor agregado correctamente'),
                                          ),
                                        );

                                        // Regresar a la pantalla anterior
                                        Navigator.pop(context);
                                      }

                                      setState(() {
                                        _isLoading = false; // Termina la carga
                                      });
                                    },
                              child: Container(
                                width: size.width,
                                decoration: BoxDecoration(
                                  color: Constants.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                child: Center(
                                  child: _isLoading
                                      ? CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        )
                                      : const Text(
                                          'Agregar datos de sensor',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
