import 'package:flutter/material.dart';
import 'package:garden_mate/providers/sensor_provider.dart';
import 'package:garden_mate/providers/user_provider.dart';
import 'package:garden_mate/screens/onboarding_screen.dart';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureAmplify();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => SensorProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> configureAmplify() async {
  try {
    final api = AmplifyAPI(modelProvider: ModelProvider.instance);
    final auth = AmplifyAuthCognito();
    await Amplify.addPlugins([api, auth]);
    await Amplify.configure(amplifyconfig);
    safePrint("Amplify configured successfully");
  } catch (e) {
    safePrint("Error configuring Amplify: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Garden Mate',
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
