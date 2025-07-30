import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/accounts.dart';
import 'package:ecom_app/expenses.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.blueAccent,
            expandedHeight: 70,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => accounts()));
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 20.0),
              child: const Text(
                'Log In',
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
                controller: userController,
                decoration: InputDecoration(
                  hintText: 'Enter Username',
                  hintStyle: const TextStyle(fontSize: 25),
                  suffixIcon: const Icon(Icons.person, size: 40),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 16.0),
                  filled: true,
                  fillColor: Colors.blueAccent,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
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
                controller: mailController,
                decoration: InputDecoration(
                  hintText: 'Enter email i.e abc@mail.com',
                  hintStyle: const TextStyle(fontSize: 25),
                  suffixIcon: const Icon(Icons.email, size: 40),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 16.0),
                  filled: true,
                  fillColor: Colors.blueAccent,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.text,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    String enteredUsername = userController.text.trim();
                    String enteredEmail = mailController.text.trim();

                    if (enteredEmail.isEmpty || enteredUsername.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Fill both fields",
                            style: TextStyle(fontSize: 19, fontFamily: 'Jost'),
                          ),
                        ),
                      );
                      return;
                    }

                    try {
                      DocumentSnapshot doc = await FirebaseFirestore.instance
                          .collection('users')
                          .doc('login')
                          .get();

                      if (doc.exists && doc.data() != null) {
                        final data = doc.data() as Map<String, dynamic>;
                        final storedEmail = data['email'];
                        final storedUsername = data['username'];

                        if (storedEmail == enteredEmail &&
                            storedUsername == enteredUsername) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const expenses()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Incorrect credentials",
                                style:
                                TextStyle(fontSize: 19, fontFamily: 'Jost'),
                              ),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "No credentials stored yet",
                              style: TextStyle(fontSize: 19, fontFamily: 'Jost'),
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Error fetching user: $e",
                            style: const TextStyle(
                                fontSize: 19, fontFamily: 'Jost'),
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Log In',
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
        ],
      ),
    );
  }
}
