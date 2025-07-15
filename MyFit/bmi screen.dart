import 'package:flutter/material.dart';

class bmiscreen extends StatefulWidget {
  const bmiscreen({super.key});

  @override
  State<bmiscreen> createState() => _bmiscreenState();
}

class _bmiscreenState extends State<bmiscreen> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  double? _bmi;

  void calcbmi() {
    final double? height = double.tryParse(heightController.text);
    final double? weight = double.tryParse(weightController.text);

    if (height != null && weight != null && height > 0) {
      final bmi = weight / (height * height); // Correct formula for meters!
      setState(() {
        _bmi = bmi;
      });
    } else {
      setState(() {
        _bmi = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.amberAccent,
            expandedHeight: 100.0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context); // Go back properly
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.black,
              ),
            ),
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'BMI',
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 26,
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Enter height in meters',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                        color: Colors.amberAccent,
                        fontFamily: 'Oswald',
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amberAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amberAccent, width: 2),
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontFamily: 'Oswald',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Enter weight in kg',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                        color: Colors.amberAccent,
                        fontFamily: 'Oswald',
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amberAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amberAccent, width: 2),
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontFamily: 'Oswald',
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: calcbmi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    ),
                    child: const Text(
                      'Calculate',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Oswald',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (_bmi != null)
                    Text(
                      'Your BMI is: ${_bmi!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.amberAccent,
                        fontFamily: 'Oswald',
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
