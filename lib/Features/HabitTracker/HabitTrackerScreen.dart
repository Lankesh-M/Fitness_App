// home_page.dart
import 'package:fitgame_app/Features/HabitTracker/HabitCommon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'HabitModel.dart';
import "HabitProvider.dart";
import "HabitSettingScreen.dart";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showCompletedHabits = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Today'), Tab(text: 'All Habits')],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showCompletedHabits ? Icons.visibility : Icons.visibility_off,
            ),
            tooltip:
                _showCompletedHabits
                    ? 'Hide completed habits'
                    : 'Show completed habits',
            onPressed: () {
              setState(() {
                _showCompletedHabits = !_showCompletedHabits;
              });
            },
          ),
        ],
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          if (habitProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // Today's habits tab
              _buildTodayTab(habitProvider),

              // All habits tab
              _buildAllHabitsTab(habitProvider),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddHabitOptions(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Habit'),
      ),
    );
  }

  Widget _buildTodayTab(HabitProvider habitProvider) {
    final todayHabits = habitProvider.getTodayHabits();
    final filteredHabits =
        _showCompletedHabits
            ? todayHabits
            : todayHabits.where((h) => !h.isCompletedToday).toList();

    if (filteredHabits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, size: 72, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              _showCompletedHabits
                  ? 'No habits to track today!'
                  : 'Great job! All habits completed for today!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HabitFormPage(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create New Habit'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredHabits.length,
      itemBuilder: (context, index) {
        final habit = filteredHabits[index];
        return _buildHabitCard(habit, habitProvider);
      },
    );
  }

  Widget _buildAllHabitsTab(HabitProvider habitProvider) {
    final habits = habitProvider.habits;

    if (habits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.trending_up, size: 72, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              'Start tracking your habits!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CommonHabitsPage(),
                    // builder: (context) => const Scaffold(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Choose from Common Habits'),
            ),
          ],
        ),
      );
    }

    // Group habits by nature (positive/negative)
    final positiveHabits = habitProvider.getHabitsByNature(
      HabitNature.positive,
    );
    final negativeHabits = habitProvider.getHabitsByNature(
      HabitNature.negative,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (positiveHabits.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Positive Habits',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...positiveHabits.map(
            (habit) => _buildHabitCard(habit, habitProvider),
          ),
        ],

        if (negativeHabits.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Breaking Bad Habits',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...negativeHabits.map(
            (habit) => _buildHabitCard(habit, habitProvider),
          ),
        ],
      ],
    );
  }

  Widget _buildHabitCard(Habit habit, HabitProvider habitProvider) {
    final isCompleted = habit.isCompletedToday;

    // Get material icon from icon name
    final IconData iconData = IconData(
      Icons.book.codePoint,
      fontFamily: 'MaterialIcons',
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () {
          habitProvider.toggleHabitCompletion(habit.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Habit icon and completion checkbox
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: habit.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(iconData, color: habit.color, size: 32),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: habit.color, width: 2),
                        ),
                        child:
                            isCompleted
                                ? Icon(
                                  Icons.check_circle,
                                  color: habit.color,
                                  size: 24,
                                )
                                : const SizedBox(width: 24, height: 24),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // Habit details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        if (habit.notes.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              habit.notes,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildHabitBadge(
                              habit.nature == HabitNature.positive
                                  ? 'Positive'
                                  : 'Breaking',
                              habit.nature == HabitNature.positive
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            _buildHabitBadge(
                              _getCategoryText(habit.trackingCategory),
                              Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Options menu
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HabitFormPage(habit: habit),
                          ),
                        );
                      } else if (value == 'delete') {
                        _showDeleteConfirmation(context, habit);
                      }
                    },
                    itemBuilder:
                        (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete),
                                SizedBox(width: 8),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ],
                  ),
                ],
              ),

              // Progress section
              const SizedBox(height: 16),
              Row(
                children: [
                  // Progress bar
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: habit.progressPercentage,
                            minHeight: 10,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              habit.color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${habit.completedDates.length} / ${habit.targetDays} days',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Streak for daily habits
                  if (habit.trackingCategory == TrackingCategory.daily)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.amber, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${habit.currentStreak} day streak',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHabitBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  String _getCategoryText(TrackingCategory category) {
    switch (category) {
      case TrackingCategory.daily:
        return 'Daily';
      case TrackingCategory.weekly:
        return 'Weekly';
      case TrackingCategory.monthly:
        return 'Monthly';
      case TrackingCategory.custom:
        return 'Custom Days';
    }
  }

  void _showAddHabitOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose an option',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                  title: const Text('Create Custom Habit'),
                  subtitle: const Text(
                    'Define your own habit with custom settings',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HabitFormPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.list, color: Colors.white),
                  ),
                  title: const Text('Choose from Common Habits'),
                  subtitle: const Text(
                    'Select from our curated list of popular habits',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const CommonHabitsPage(), //Changed here
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Habit'),
          content: Text(
            'Are you sure you want to delete "${habit.title}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // FilledButton(
            //   child: const Text('DELETE'),
            //   onPressed: () {
            //     Provider.of<HabitProvider>(
            //       context,
            //       listen: false,
            //     ).deleteHabit(habit.id);
            //     Navigator.of(context).pop();
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text('${habit.title} has been deleted'),
            //         behavior: SnackBarBehavior.floating,
            //         action: SnackBarAction(
            //           label: 'UNDO',
            //           onPressed: () {
            //             Provider.of<HabitProvider>(
            //               context,
            //               listen: false,
            //             ).restoreHabit();
            //           },
            //         ),
            //       ),
            //     );
            //   },
            // ),
          ],
        );
      },
    );
  }
}
