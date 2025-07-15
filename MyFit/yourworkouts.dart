import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:my_fit/menu_screen.dart';

class YourWorkoutsScreen extends StatefulWidget {
  const YourWorkoutsScreen({super.key});

  @override
  State<YourWorkoutsScreen> createState() => _YourWorkoutsScreenState();
}

class _YourWorkoutsScreenState extends State<YourWorkoutsScreen> {
  List<String> days = [];
  List<String> labels = [];
  List<List<String>> exercises = [];

  @override
  void initState() {
    super.initState();
    loadWorkout();
  }

  void loadWorkout() async {
    final prefs = await SharedPreferences.getInstance();

    days = prefs.getStringList('savedDays') ?? [];
    labels = prefs.getStringList('savedLabels') ?? [];

    final exercisesJson = prefs.getString('savedExercises');
    if (exercisesJson != null) {
      List<dynamic> decoded = jsonDecode(exercisesJson);
      exercises = decoded.map<List<String>>((e) => List<String>.from(e)).toList();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.amberAccent,
            foregroundColor: Colors.black,
            pinned: true,
            expandedHeight: 100.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const menuScreen()),
                );
              },
            ),
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Your Workouts',
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          days.isEmpty
              ? SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'No workout saved.',
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          )
              : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${days[index]} — ${labels[index].isEmpty ? 'Not named' : labels[index]}',
                          style: const TextStyle(
                            fontFamily: 'Oswald',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (exercises[index].isEmpty)
                          const Text(
                            'No exercises added.',
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          )
                        else
                          ...exercises[index]
                              .map(
                                (e) => Text(
                              '- $e',
                              style: const TextStyle(
                                fontFamily: 'Oswald',
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          )
                              .toList(),
                      ],
                    ),
                  ),
                );
              },
              childCount: days.length,
            ),
          ),
        ],
      ),
    );
  }
}
