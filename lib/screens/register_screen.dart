import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nommetric/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(35, 16, 35, 0),
            child: Column(
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
                    'Create an account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Text(
                    'Get to know about all the Nommetric simply by creating a new account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),

                SizedBox(height: 24.0),
                // Name TextField
                TextField(
                  decoration: InputDecoration(
                    labelText: "Enter Your Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  ),
                ),
                SizedBox(height: 15.0),
                // Email TextField
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Enter Your Email / Roll no.",
                    hintText: "example@gmail.com",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  ),
                ),
                SizedBox(height: 15.0),
                // Password TextField
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Enter Your Password",
                    suffix: Icon(CupertinoIcons.eye_solid),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 15.0),
                // Confirm Password TextField
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    suffix: Icon(CupertinoIcons.eye_solid),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20.0),
                // Sign Up Button
                ElevatedButton(
                  onPressed: () async{
                    if(passwordController.text != confirmPasswordController.text){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Passwords do not match")),
                      );
                      return;
                    }
                    
                    try {
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim()
                      );
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder:  (context) => LoginScreen())
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
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
                    "Sign Up",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),

                
                SizedBox(height: 16.0),
                // Already have an account link
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Already have an account?  ",
                      children: [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                color: Colors.deepPurple.withOpacity(0.4),
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