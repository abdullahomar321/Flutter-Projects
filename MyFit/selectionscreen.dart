import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:my_fit/main.dart';

class selection extends StatefulWidget {
  final List<String> days;

  const selection({super.key, required this.days});

  @override
  State<selection> createState() => _selectionState();
}

class _selectionState extends State<selection> {
  late List<String> labels;
  late List<List<String>> exercises;

  final List<String> availableExercises = [
    'Bench Press',
    'Rows',
    'Deadlifts',
    'Squats',
    'Planks',
    'Weighted Dips',
    'Weighted Pullup',
    'Weighted Chinup',
    'Bicep Curls',
    'Shoulder Press',
    'Pike Press',
    'Forearm Curls',
    'Farmer Carry',
    'Lateral Raises',
    'Rear Delt Flys',
    'Shrugs',
    'Hammer Curls',
    'Tricep Pushdown',
    'Tricep Bench Dips',
    'Hip Thrust',
    'Russian Twists',
    'L Sit',
    'Close Grip Bench',
    'Leg Lifts',
    'Goblet Squat',
    'Peck Deck',
    'Butter Fly',
    'Lat Pulldown',
    'Seated Rows',
    'Skull Crushers',
    'One Arm Rows',
    'Hollow Holds',
  ];

  @override
  void initState() {
    super.initState();
    labels = List<String>.filled(widget.days.length, '');
    exercises = List.generate(widget.days.length, (_) => []);
  }
  void saveWorkout() async {
    final prefs = await SharedPreferences.getInstance();

    // Save days & labels as StringLists
    await prefs.setStringList('savedDays', widget.days);
    await prefs.setStringList('savedLabels', labels);

    // Save exercises (list of lists) as JSON string
    final exercisesJson = jsonEncode(exercises);
    await prefs.setString('savedExercises', exercisesJson);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout saved successfully!')),
    );
  }

  void renameDay(int index) async {
    String? newLabel = await showDialog<String>(
      context: context,
      builder: (context) {
        String temp = labels[index];
        return AlertDialog(
          title: const Text('Name this Day'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
                hintText: 'Push, Pull, Upper, Legs...'),
            onChanged: (value) {
              temp = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, temp),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newLabel != null && newLabel.trim().isNotEmpty) {
      setState(() {
        labels[index] = newLabel.trim();
      });
    }
  }

  void addExercise(int dayIndex) async {
    final List<String> selected = List.from(exercises[dayIndex]);

    final List<String>? result = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Select Exercises'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                children: availableExercises.map((exercise) {
                  final isSelected = selected.contains(exercise);
                  return CheckboxListTile(
                    title: Text(exercise),
                    value: isSelected,
                    onChanged: (bool? checked) {
                      setState(() {
                        if (checked == true) {
                          selected.add(exercise);
                        } else {
                          selected.remove(exercise);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, selected),
                child: const Text('Save'),
              ),
            ],
          );
        });
      },
    );

    if (result != null) {
      setState(() {
        exercises[dayIndex] = result;
      });
    }
  }

  void viewExercises(int dayIndex) {
    final List<String> dayExercises = exercises[dayIndex];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '${widget.days[dayIndex]} — ${labels[dayIndex].isEmpty ? '' : labels[dayIndex]}',
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: dayExercises.isEmpty
              ? const Text('No exercises added.')
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: dayExercises
                .map((e) => ListTile(title: Text(e)))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
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
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const IntroScreen()),
                );
              },
              icon:
              const Icon(Icons.arrow_back, size: 30, color: Colors.black),
            ),
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Plan Your Workouts',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Oswald',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10),
                  child: Container(
                    height: 95,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed: () => renameDay(index),
                        ),
                        Expanded(
                          child: Text(
                            '${widget.days[index]} — ${labels[index].isEmpty ? 'Not named' : labels[index]}',
                            style: const TextStyle(
                              fontSize: 23,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.black),
                          onPressed: () => addExercise(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye,
                              color: Colors.black),
                          onPressed: () => viewExercises(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: widget.days.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    foregroundColor: Colors.black,
                    textStyle: const TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: saveWorkout,
                  child: const Text('Save Workout'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
