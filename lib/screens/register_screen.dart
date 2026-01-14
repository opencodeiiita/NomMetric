import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../app_home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final rollController = TextEditingController();
  final roomController = TextEditingController();

  String selectedHostel = 'BH1';
  final List<String> hostels = ['BH1', 'BH2', 'BH3', 'BH4'];

  bool isLoading = false;

  // --- NEW: Variables to track password visibility ---
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  // ---------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(35, 40, 35, 20),
            child: Column(
              children: [
                const Text(
                  "Nommetric",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff0E64D2),
                  ),
                ),
                const SizedBox(height: 32.0),
                const Text(
                  'Create an account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Get to know about all the Nommetric simply by creating a new account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 24.0),

                // Name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Enter Your Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),

                // Email
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Enter Your Email",
                    hintText: "example@gmail.com",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),

                // Roll Number & Room Number
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: rollController,
                        decoration: const InputDecoration(
                          labelText: "Roll No",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: roomController,
                        decoration: const InputDecoration(
                          labelText: "Room No",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),

                // Hostel Dropdown
                DropdownButtonFormField<String>(
                  value: selectedHostel,
                  decoration: const InputDecoration(
                    labelText: "Select Hostel",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  items: hostels.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedHostel = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 15.0),

                // --- FIXED PASSWORD FIELD ---
                TextField(
                  controller: passwordController,
                  // Toggles between true (hidden) and false (visible)
                  obscureText: !_isPasswordVisible, 
                  decoration: InputDecoration(
                    labelText: "Enter Your Password",
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    // Clickable Icon Button
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Change icon based on state
                        _isPasswordVisible 
                            ? CupertinoIcons.eye_slash_fill 
                            : CupertinoIcons.eye_fill,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),

                // --- FIXED CONFIRM PASSWORD FIELD ---
                TextField(
                  controller: confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible 
                            ? CupertinoIcons.eye_slash_fill 
                            : CupertinoIcons.eye_fill,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Sign Up Button
                isLoading 
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: () async {
                    if (passwordController.text != confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Passwords do not match")),
                      );
                      return;
                    }
                    if (nameController.text.isEmpty || rollController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields")),
                      );
                      return;
                    }

                    setState(() => isLoading = true);

                    try {
                      UserCredential cred = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );

                      if (cred.user != null) {
                        UserModel newUser = UserModel(
                          uid: cred.user!.uid,
                          email: emailController.text.trim(),
                          name: nameController.text.trim(),
                          rollNumber: rollController.text.trim(),
                          hostel: selectedHostel,
                          roomNumber: roomController.text.trim(),
                          createdAt: DateTime.now(),
                        );

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(cred.user!.uid)
                            .set(newUser.toMap());

                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const AppHome()),
                            (route) => false,
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text(e.toString())),
                        );
                      }
                    } finally {
                      if (mounted) setState(() => isLoading = false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xff0E64D2),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),

                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
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
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                            color: const Color(0xff2F89FC),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    style: const TextStyle(
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