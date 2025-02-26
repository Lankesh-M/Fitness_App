import 'package:flutter/material.dart';
import 'dart:async';

class WorkoutQuestPage extends StatefulWidget {
  const WorkoutQuestPage({super.key});

  @override
  _WorkoutQuestPageState createState() => _WorkoutQuestPageState();
}

class _WorkoutQuestPageState extends State<WorkoutQuestPage> {
  late Timer _timer;
  late Duration _timeUntilMidnight;

  @override
  void initState() {
    super.initState();
    _calculateTimeUntilMidnight();
    _startTimer();
  }

  void _calculateTimeUntilMidnight() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    _timeUntilMidnight = tomorrow.difference(now);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _calculateTimeUntilMidnight();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A2980), // Deep blue
              const Color.fromARGB(255, 6, 133, 131), // Teal accent
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Timer section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Time Left - ${_formatDuration(_timeUntilMidnight)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(
                        "Workout",
                        Icons.fitness_center,
                        Colors.orange.shade800,
                        () {
                          // Handle workout tap
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildButton(
                        "Quest",
                        Icons.star,
                        Colors.purple.shade800,
                        () {
                          // Handle quest tap
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      width: double.infinity,
      height: 120,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          // shadowColor: Colors.black,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          elevation: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Icon(icon, size: 40, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class DailyTaskPage extends StatefulWidget {
//   @override
//   _DailyTaskPageState createState() => _DailyTaskPageState();
// }

// class _DailyTaskPageState extends State<DailyTaskPage> {
//   late Timer _timer;
//   Duration _timeLeft = Duration();

//   @override
//   void initState() {
//     super.initState();
//     _calculateTimeLeft();
//     _startTimer();
//   }

//   void _calculateTimeLeft() {
//     final now = DateTime.now();
//     final midnight = DateTime(now.year, now.month, now.day + 1);
//     _timeLeft = midnight.difference(now);
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         _timeLeft = _timeLeft - Duration(seconds: 1);
//         if (_timeLeft.isNegative) {
//           _calculateTimeLeft();
//         }
//       });
//     });
//   }

//   String _formatTime(Duration duration) {
//     return DateFormat("HH:mm:ss").format(
//       DateTime(0).add(duration),
//     );
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildButton("Workout", Colors.blueAccent),
//                 _buildButton("Quest", Colors.greenAccent),
//               ],
//             ),
//             Positioned(
//               top: 20,
//               right: 20,
//               child: Container(
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   _formatTime(_timeLeft),
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildButton(String text, Color color) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {},
//         child: Container(
//           margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [color.withOpacity(0.7), color],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(15),
//             boxShadow: [
//               BoxShadow(
//                 color: color.withOpacity(0.4),
//                 blurRadius: 10,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: Center(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
