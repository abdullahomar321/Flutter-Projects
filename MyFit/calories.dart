import 'package:flutter/material.dart';
import 'package:my_fit/menu_screen.dart';

class Calories extends StatefulWidget {
  const Calories({super.key});

  @override
  State<Calories> createState() => _CaloriesState();
}

class _CaloriesState extends State<Calories> {
  final _formKey = GlobalKey<FormState>();

  String _gender = 'Male';
  double _weight = 0;
  double _height = 0;
  int _age = 0;
  double _activityFactor = 1.2;

  double? _maintenanceCalories;

  double calculateMaintenanceCalories() {
    double bmr;
    if (_gender.toLowerCase() == 'male') {
      bmr = 88.362 + (13.397 * _weight) + (4.799 * _height) - (5.677 * _age);
    } else {
      bmr = 447.593 + (9.247 * _weight) + (3.098 * _height) - (4.330 * _age);
    }
    return bmr * _activityFactor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            backgroundColor: Colors.amberAccent,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Track your Calories',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Oswald',
                ),
              ),
              centerTitle: true,
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const menuScreen()),
                );
              },
              icon: Icon(Icons.arrow_back, size: 30, color: Colors.black),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _gender,
                      items: ['Male', 'Female'].map((gender) {
                        return DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your weight';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _weight = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Height (cm)',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your height';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _height = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Age',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your age';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _age = int.parse(value!);
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<double>(
                      value: _activityFactor,
                      items: [
                        DropdownMenuItem(
                            value: 1.2,
                            child: Text('Sedentary (little/no exercise)')),
                        DropdownMenuItem(
                            value: 1.375,
                            child: Text('Lightly active (1–3 days/week)')),
                        DropdownMenuItem(
                            value: 1.55,
                            child: Text('Moderately active (3–5 days/week)')),
                        DropdownMenuItem(
                            value: 1.725,
                            child: Text('Very active (6–7 days/week)')),
                        DropdownMenuItem(
                            value: 1.9,
                            child: Text(
                                'Extra active (physical job + training)')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Activity Level',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _activityFactor = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            _maintenanceCalories =
                                calculateMaintenanceCalories();
                          });
                        }
                      },
                      child: const Text(
                        'Calculate',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (_maintenanceCalories != null)
                      Text(
                        'Your maintenance calories: ${_maintenanceCalories!.round()} kcal/day',
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
