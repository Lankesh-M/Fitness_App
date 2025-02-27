import 'package:fitgame_app/Features/Home/DailyTask.dart';
import 'package:fitgame_app/Features/Home/GameScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = "/actual-home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController; // Add TabController

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    ); // Initialize with 2 tabs
    _tabController.addListener(() {
      setState(() {}); // Update state when tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Hello, User"),
      ),
      //   bottom: TabBar(
      //     controller: _tabController, // Connect TabBar to TabController
      //     indicatorColor: Colors.green,
      //     indicatorWeight: 10,
      //     labelColor: Colors.green,
      //     labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      //     tabs: const [
      //       Tab(
      //         // icon: Icon(Icons.fitness_center_outlined, size: 25),
      //         child: Text('Real Life'),
      //       ),
      //       Tab(
      //         // icon: Icon(Icons.play_arrow_outlined, size: 25),
      //         child: Text('Game Life'),
      //       ),
      //     ],
      //   ),
      // ),
      body: const WorkoutQuestPage(),
    );
  }
}
