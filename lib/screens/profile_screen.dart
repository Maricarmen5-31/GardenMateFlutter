import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:garden_mate/providers/user_provider.dart';
import 'package:garden_mate/screens/onboarding_screen.dart';
import 'package:garden_mate/shared/extensions.dart';
import 'package:garden_mate/utils/constants.dart';
import 'package:garden_mate/widgets/profile_widget.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Constants.primaryColor.withOpacity(.5),
                    width: 5.0,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 60,
                  backgroundImage: ExactAssetImage('assets/images/profile.jpg'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width * .3,
                child: Row(
                  children: [
                    const Text(
                      'Leticia Perez',
                      style: TextStyle(
                        color: Constants.blackColor,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 24,
                      child: Image.asset("assets/images/verified.png"),
                    ),
                  ],
                ),
              ),
              Text(
                'leticia_perez@gmail.com',
                style: TextStyle(
                  color: Constants.blackColor.withOpacity(.3),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: size.height * .7,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ProfileWidget(
                      icon: Icons.person,
                      title: 'Mi perfil',
                    ),
                    const ProfileWidget(
                      icon: Icons.settings,
                      title: 'Configuraciones',
                    ),
                    const ProfileWidget(
                      icon: Icons.notifications,
                      title: 'Notificaciones',
                    ),
                    const ProfileWidget(
                      icon: Icons.chat,
                      title: 'FAQs',
                    ),
                    const ProfileWidget(
                      icon: Icons.share,
                      title: 'Compartir',
                    ),
                    // Utiliza el ProfileWidget personalizado para el botón de "Cerrar sesión"
                    ProfileWidget(
                      icon: Icons.border_all_rounded,
                      title: 'Cerrar sesión',
                      isLoading: context.watch<UserProvider>().isLoading,
                      onTap: () async {
                        final response =
                            await context.read<UserProvider>().signOut();
                        response.fold(
                          (error) => context.showError(error),
                          (result) {
                            if (result is CognitoCompleteSignOut) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const OnboardingScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
