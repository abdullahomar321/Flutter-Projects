import 'package:ecom_app/verification.dart';
import 'package:ecom_app/accounts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class signin extends StatefulWidget {
  const signin({super.key});

  @override
  State<signin> createState() => _SignInState();
}

class _SignInState extends State<signin> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> storeUser() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();

    if (username.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields',style: TextStyle(fontSize: 19),)),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc('login') // Single user document
          .set({
        'username': username,
        'email': email,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Verify(email: emailController.text.trim(), username: usernameController.text.trim())),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 70,
            pinned: true,
            backgroundColor: Colors.blueAccent,
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const accounts(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 20.0),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 90,
                  fontFamily: 'Jost',
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Enter Username',
                  hintStyle: const TextStyle(fontSize: 25),
                  suffixIcon: const Icon(Icons.person, size: 40),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                  filled: true,
                  fillColor: Colors.blueAccent,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter email i.e abc@mail.com',
                  hintStyle: const TextStyle(fontSize: 25),
                  suffixIcon: const Icon(Icons.email, size: 40),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                  filled: true,
                  fillColor: Colors.blueAccent,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: storeUser,
                  child: const Text(
                    'Verify',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }
}
