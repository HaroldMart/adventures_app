import 'package:firebase_auth/firebase_auth.dart';
import '/reusable_widgets/reusable_widget.dart';
import 'home_screen.dart';
import 'package:logger/logger.dart';
import '/utils/color_utils.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
  
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  final Logger _logger = Logger();
  String errorMessage = "";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
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
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Sign Up", () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((userCredential) {
                         User? user = userCredential.user;
                         user?.sendEmailVerification();
                         
                         const Text("Created New Account");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).onError((error, stackTrace) {
                   _logger.e("Error ${error.toString()}");

                    showErrors(error.toString());
                  });
                }),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                )
              ],
            ),
          ))),
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
