import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:garden_mate/providers/user_provider.dart';
import 'package:garden_mate/screens/forgotPassword_screen.dart';
import 'package:garden_mate/screens/navigation_screen.dart';
import 'package:garden_mate/screens/register_screen.dart';
import 'package:garden_mate/shared/extensions.dart';
import 'package:garden_mate/utils/constants.dart';
import 'package:garden_mate/widgets/custom_textfield.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late String _username, _password;
  bool _isLoggingIn = false;

  void signIn({required String username, required String password}) async {
    setState(() {
      _isLoggingIn = true;
    });

    try {
      final signInResponse = await context
          .read<UserProvider>()
          .signIn(username: username, password: password);

      signInResponse.fold(
        (error) {
          context.showError(error);
          setState(() {
            _isLoggingIn = false;
          });
        },
        (signInResult) {
          if (signInResult.nextStep.signInStep == AuthSignInStep.done) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Navigation(),
              ),
              (route) => false,
            );
          }
        },
      );
    } catch (error) {
      context.showError(
          error is SignedOutException ? error.message : error.toString());
      setState(() {
        _isLoggingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final loginButtonChild = _isLoggingIn
        ? const CircularProgressIndicator(color: Colors.white)
        : const Text(
            'Iniciar sesión',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/signin.png'),
                const Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextfield(
                  obscureText: false,
                  hintText: 'Usuario',
                  icon: Icons.person,
                  onChanged: (username) {
                    _username = username;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingresa tu nombre de usuario';
                    }
                    return null;
                  },
                  onSaved: (username) {
                    _username = username;
                  },
                ),
                CustomTextfield(
                  obscureText: true,
                  hintText: 'Contraseña',
                  icon: Icons.lock,
                  onChanged: (password) {
                    _password = password;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingresa tu contraseña';
                    }
                    return null;
                  },
                  onSaved: (password) {
                    _password = password;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      signIn(username: _username, password: _password);
                    }
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
                      child: loginButtonChild,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: const ForgotPassword(),
                            type: PageTransitionType.bottomToTop));
                  },
                  child: Center(
                    child: Text.rich(
                      TextSpan(children: [
                        const TextSpan(
                          text: '¿Has olvidado tu contraseña?  ',
                          style: TextStyle(
                            color: Constants.blackColor,
                          ),
                        ),
                        TextSpan(
                          text: 'Restablecer contraseña',
                          style: TextStyle(
                            color: Constants.primaryColor,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('O'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: const Register(),
                            type: PageTransitionType.bottomToTop));
                  },
                  child: Center(
                    child: Text.rich(
                      TextSpan(children: [
                        const TextSpan(
                          text: 'Nuevo en Garden Mate? ',
                          style: TextStyle(
                            color: Constants.blackColor,
                          ),
                        ),
                        TextSpan(
                          text: 'Registrarse',
                          style: TextStyle(
                            color: Constants.primaryColor,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
