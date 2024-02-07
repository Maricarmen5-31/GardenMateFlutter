import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:garden_mate/providers/user_provider.dart';
import 'package:garden_mate/screens/login_screen.dart';
import 'package:garden_mate/screens/verification_screen.dart';
import 'package:garden_mate/shared/extensions.dart';
import 'package:garden_mate/utils/constants.dart';
import 'package:garden_mate/widgets/custom_textfield.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  late String _username = '';
  late String _email = '';
  late String _password = '';

  void signUp(String username, String email, String password) async {
    final signUpResult =
        await context.read<UserProvider>().signUp(username, password, email);
    signUpResult.fold(
      (error) => context.showError(error),
      (step) {
        if (step.nextStep.signUpStep == AuthSignUpStep.confirmSignUp) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationScreen(username: username),
            ),
          );
        } else {}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/signup.png'),
                const Text(
                  'Resgistrarse',
                  textAlign: TextAlign.end,
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
                  hintText: 'Correo',
                  icon: Icons.alternate_email,
                  onChanged: (email) {
                    _email = email;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingresa tu correo';
                    }
                    return null;
                  },
                  onSaved: (email) {
                    _email = email;
                  },
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
                      signUp(_username, _email, _password);
                    }
                  },
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Constants.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: Center(
                      child: context.watch<UserProvider>().isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Registrarse',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
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
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: const Login(),
                            type: PageTransitionType.bottomToTop));
                  },
                  child: Center(
                    child: Text.rich(
                      TextSpan(children: [
                        const TextSpan(
                          text: '¿Tienes una cuenta? ',
                          style: TextStyle(
                            color: Constants.blackColor,
                          ),
                        ),
                        TextSpan(
                          text: 'Iniciar sesión',
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
