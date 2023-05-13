import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:project2/Screens/verify.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _fullNameController = TextEditingController();
  final _emilController = TextEditingController();
  final _passwordController = TextEditingController();
  final _blockController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _nationalIDController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  usersCollection() {
    FirebaseFirestore.instance.collection("Users").add({
      "Full Name": _fullNameController.text,
      "E-mail": _emilController.text,
      "Block": _blockController.text,
      "Street": _streetController.text,
      "City": _cityController.text,
      "Nationa ID": _nationalIDController.text,
      "Phone Number": _phoneNumberController.text,
    });
  }

  void loginScreen() {
    Navigator.of(context).pushReplacementNamed('loginScreen');
  }

  Future signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emilController.text.trim(),
            password: _passwordController.text.trim(),
          )
          .then((value) => usersCollection());
      // .then((value) =>  VerifyScreen());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "The password is too weak.",
            ),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "The account already exists for that email.",
            ),
          ),
        );
      }
    }
    Navigator.of(context).pushNamed('/');
  }

  @override
  void dispose() {
    super.dispose();
    _emilController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: const BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
              Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.network(
                        'https://assets5.lottiefiles.com/packages/lf20_KvK0ZJBQzu.json'),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "SIGN UP",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return "Enter Your Name";
                            }
                          },
                          controller: _fullNameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: "Full Name",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value!.contains("@")) {
                                return "Enter Your E-mail";
                              }
                            },
                            controller: _emilController,
                            decoration: const InputDecoration(
                              hintText: "E-mail",
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Enter Your Password";
                              }
                            },
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: "Password",
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Padding(
                            padding: EdgeInsets.only(left: 25),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Enter Your Block";
                                  }
                                },
                                controller: _blockController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Block",
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Padding(
                            padding: EdgeInsets.only(right: 25),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Enter Your Street";
                                  }
                                },
                                controller: _streetController,
                                decoration: InputDecoration(
                                  hintText: "Street",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return "Enter Your City";
                            }
                          },
                          controller: _cityController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "City",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return "Enter Your National ID";
                            }
                          },
                          controller: _nationalIDController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "National ID",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Enter Your Phone Number";
                              }
                            },
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: "Phone Number",
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          signUp();
                        }
                      },
                      child: const Text("Sign Up"),
                    ),
                    TextButton(
                      onPressed: () {
                        loginScreen();
                      },
                      child: const Text("Already have an Account?"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
