import 'package:firebase_auth/firebase_auth.dart';
import '/reusable_widgets/reusable_widget.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'package:logger/logger.dart';
import '/utils/color_utils.dart';
import '../functions/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  String errorMessage = "";
  final Logger _logger = Logger();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/logo1.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField(
                    "Correo", IconlyBold.profile, false, _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Contraseña", IconlyBold.lock, true,
                    _passwordTextController),
                const SizedBox(
                  height: 5,
                ),
                firebaseUIButton(context, "Sign In", () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  }).onError((error, stackTrace) {
                    _logger.e("Error ${error.toString()}");

                    showErrors(error.toString());
                  });
                }),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Log in with:',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                IconButton(
                    icon: Image.asset('assets/images/google.png'),
                    iconSize: 40,
                    style: const ButtonStyle(
                      foregroundColor: MaterialStatePropertyAll(Colors.white),
                      backgroundColor: MaterialStatePropertyAll(Colors.white)
                    ),
                    onPressed: () async {
                      await signInWithGoogle().then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      });
                    }),
                const SizedBox(
                  height: 40,
                ),
                signUpOption(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  void showErrors(String error) {
    if (error.toString().contains("The email address is badly formatted")) {
      setState(() {
        errorMessage = "Error: Email not formatted";
      });
    } else if (error
        .toString()
        .contains("Unable to establish connection on channel")) {
      setState(() {
        errorMessage = "Error: Fill the fields";
      });
    } else if (error.toString().contains(
        "The password is invalid or the user does not have a password")) {
      setState(() {
        errorMessage = "Error: Invalid Password";
      });
    } else if (error.toString().contains(
        "There is no user record corresponding to this identifier. The user may have been deleted.")) {
      setState(() {
        errorMessage = "Error: The user does not exist";
      });
    }
  }
}
