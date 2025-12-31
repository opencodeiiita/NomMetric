import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nommetric/home.dart';
import 'package:nommetric/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(36, 16, 36, 0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Nommetric",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff0E64D2),
                  ),
                ),

                SizedBox(height: 32.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Hi, Nommetric Welcomes you 👋',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 38.0),
                    Text(
                      "Email / Roll no.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff695C5C),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "example@gmail.com",
                        hintStyle: TextStyle(fontWeight: FontWeight.w400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff695C5C),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        hintStyle: TextStyle(fontWeight: FontWeight.w400),
                        suffixIcon: Icon(CupertinoIcons.eye_solid),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () async{
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Home()),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Invalid credentials")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xff0E64D2),
                    minimumSize: Size(double.infinity, 48), // Full-width button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),

                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Don’t have an account ?  ",
                      children: [
                        TextSpan(
                          text: "SignUp",
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                color: Colors.blue.withOpacity(0.4),
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                            color: Color(0xff2F89FC),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    style: TextStyle(
                      color: Color(0xff0D0E0E),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
