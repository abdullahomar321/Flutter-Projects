import 'package:flutter/material.dart';
import 'package:ecom_app/accounts.dart';

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            expandedHeight: 100,
            backgroundColor: Colors.blueAccent,
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -40),
                    child: Container(
                      height: 400,
                      width: 400,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 20,
                          offset: Offset(0, 10), // optional: adds vertical shadow
                        ),
                        ],
                      ),
                      child: const Center(
                        child: FittedBox(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Budge-It',
                              style: TextStyle(
                                fontFamily: 'Jost',
                                fontWeight: FontWeight.bold,
                                fontSize: 100,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                        color: Colors.black,
                        blurRadius: 20,
                          offset: Offset(0, 10)
                        ),
                      ]
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>accounts()));
                      },
                      child: const Text(
                        'Start',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
