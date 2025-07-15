import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_fit/menu_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  bool _isRunning = false;

  final List<Duration> _laps = [];

  void _startTime() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _elapsed += const Duration(seconds: 1);
        });
      });
    }
  }

  void _stopTime() {
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false;
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    setState(() {
      _elapsed = Duration.zero;
    });
  }

  void _addLap() {
    if (_elapsed > Duration.zero) {
      setState(() {
        _laps.insert(0, _elapsed);
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            backgroundColor: Colors.amberAccent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const menuScreen()),
                );
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 0),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'StopWatch',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Oswald',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: _addLap,
                          icon: const Icon(Icons.add, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    color: Colors.amberAccent,
                    child: SizedBox(
                      height: 320,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 200,
                            width: 200,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Transform.scale(
                                  scale: 4.0,
                                  child: CircularProgressIndicator(
                                    value: null,
                                    strokeWidth: 4,
                                    backgroundColor: Colors.black12,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                                  ),
                                ),
                                Text(
                                  _formatDuration(_elapsed),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Oswald',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: _startTime,
                                icon: const Icon(Icons.play_arrow, color: Colors.black),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: _stopTime,
                                icon: const Icon(Icons.stop, color: Colors.black),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: _resetTimer,
                                icon: const Icon(Icons.restart_alt, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _laps.length,
                    itemBuilder: (context, index) {
                      final lapTime = _laps[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(16.0),
                        height: 80,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _formatDuration(lapTime),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Oswald',
                                  ),
                                ),
                                const SizedBox(width: 30),
                                Text(
                                  'Lap ${_laps.length - index}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Oswald',
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                setState(() {
                                  _laps.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
