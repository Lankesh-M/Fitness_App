import 'package:fitgame_app/Features/HabitTracker/HabitModel.dart';
import 'package:fitgame_app/Features/HabitTracker/HabitProvider.dart';
import 'package:fitgame_app/Features/HabitTracker/HabitSettingScreen.dart';
import 'package:fitgame_app/Features/HabitTracker/HabitTrackerScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CommonHabitsPage extends StatefulWidget {
  // Constructor
  const CommonHabitsPage({Key? key}) : super(key: key);

  @override
  State<CommonHabitsPage> createState() => _CommonHabitsPageState();
}

class _CommonHabitsPageState extends State<CommonHabitsPage> {
  @override
  Widget build(BuildContext context) {
    // Get the list of predefined habits from our utility class
    final predefinedHabits = PredefinedHabits.getDefaultHabits();

    // Access the habit provider
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Habit'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Predefined Habits',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose from our collection of popular habits or create your own.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two cards per row
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio:
                      0.8, // Control card height relative to width
                ),
                itemCount: predefinedHabits.length,
                itemBuilder: (context, index) {
                  final habit = predefinedHabits[index];
                  return _buildHabitCard(context, habit, habitProvider);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to custom habit creation page
          Navigator.pop(context);
          // You would typically navigate to a form for creating a custom habit
          // For example: Navigator.push(context, MaterialPageRoute(builder: (context) => CreateHabitPage()));
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        child: const Icon(Icons.add),
        tooltip: 'Create custom habit',
      ),
    );
  }

  // Build an individual habit card
  Widget _buildHabitCard(
    BuildContext context,
    Habit habit,
    HabitProvider provider,
  ) {
    // Convert string icon name to IconData
    IconData iconData = Icons.bookmark;
    try {
      // Try to find the icon by name
      iconData = IconData(
        // The following retrieves the codePoint for the icon
        // This is a simplified approach and might not work for all icons
        Icons.book.codePoint,
        fontFamily: 'MaterialIcons',
      );

      // This is a map of common icon names to their corresponding Icons
      final Map<String, IconData> iconMap = {
        'book': Icons.book,
        'alarm': Icons.alarm,
        'directions_run': Icons.directions_run,
        'code': Icons.code,
        'smoke_free': Icons.smoke_free,
        'self_improvement': Icons.self_improvement,
        'bookmark': Icons.bookmark,
      };

      // Look up the icon in our map
      if (iconMap.containsKey(habit.icon)) {
        iconData = iconMap[habit.icon]!;
      }
    } catch (e) {
      // Fallback to default icon if lookup fails
      iconData = Icons.bookmark;
    }

    // Get appropriate badge icon based on habit nature
    IconData badgeIcon =
        habit.nature == HabitNature.positive
            ? Icons.add_circle
            : Icons.remove_circle;

    // Get string representation of tracking frequency
    String frequencyText = _getFrequencyText(habit);

    // Check if the habit already exists in the user's collection
    bool habitExists = provider.habits.any((h) => h.title == habit.title);

    return GestureDetector(
      onTap: () {
        // Show confirmation dialog for adding the habit
        _showAddHabitDialog(context, habit, provider, habitExists);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [habit.color.withOpacity(0.7), habit.color],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row with icon and badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.3),
                        child: Icon(iconData, color: Colors.white),
                      ),
                      Icon(
                        badgeIcon,
                        color:
                            habit.nature == HabitNature.positive
                                ? Colors.green[300]
                                : Colors.red[300],
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Habit title
                  Text(
                    habit.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Frequency text
                  Text(
                    frequencyText,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Target days
                  Text(
                    'Goal: ${habit.targetDays} days',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // View details button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Show more details in a dialog
                          _showHabitDetails(
                            context,
                            habit,
                            provider,
                            habitExists,
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                        ),
                        child: const Text(
                          'Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Show an "Added" indicator if the habit already exists
            if (habitExists)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Added',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper to get a readable frequency text
  String _getFrequencyText(Habit habit) {
    switch (habit.trackingCategory) {
      case TrackingCategory.daily:
        return 'Every day';
      case TrackingCategory.custom:
        // For custom, show which days are tracked
        final days = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
        final selectedDays = <String>[];

        for (int i = 0; i < 7; i++) {
          if (habit.daysToTrack[i]) {
            selectedDays.add(days[i]);
          }
        }

        return selectedDays.join(', ');
    }
  }

  // Show a dialog with habit details
  void _showHabitDetails(
    BuildContext context,
    Habit habit,
    HabitProvider provider,
    bool habitExists,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(habit.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Type: ${habit.nature == HabitNature.positive ? 'Positive' : 'Negative'}',
                ),
                const SizedBox(height: 8),
                Text('Frequency: ${_getFrequencyText(habit)}'),
                const SizedBox(height: 8),
                Text('Target: ${habit.targetDays} days'),
                if (habit.notes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Notes: ${habit.notes}'),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
              if (!habitExists)
                FilledButton(
                  onPressed: () {
                    // Add the habit to the provider
                    _addHabitToProvider(context, habit, provider);
                  },
                  child: const Text('Add Habit'),
                ),
              if (habitExists)
                FilledButton(
                  onPressed: () {
                    // Show a message that the habit already exists
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'This habit is already in your collection',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Already Added'),
                ),
            ],
          ),
    );
  }

  // Show dialog to confirm adding a habit
  void _showAddHabitDialog(
    BuildContext context,
    Habit habit,
    HabitProvider provider,
    bool habitExists,
  ) {
    if (habitExists) {
      // Show a message that the habit already exists
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This habit is already in your collection'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Habit'),
            content: Text(
              'Would you like to add "${habit.title}" to your habits?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  //Rerender the page
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  // Add the habit to the provider and Customize acc to user needs
                  _addHabitToProvider(context, habit, provider);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HabitFormPage(habit: habit),
                    ),
                  );
                },
                child: const Text('Customize'),
              ),
              FilledButton(
                onPressed: () {
                  // Add the habit to the provider
                  _addHabitToProvider(context, habit, provider);
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  // Add the habit to the provider and show a success message
  void _addHabitToProvider(
    BuildContext context,
    Habit habit,
    HabitProvider provider,
  ) {
    // Add the habit to the provider
    provider.addHabit(habit);

    // Close the dialog
    Navigator.pop(context);

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${habit.title} has been added to your habits'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Habits',
          onPressed: () {
            Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => HabitTrackerScreen(), //Changed here
            //   ),
            // );
          },
        ),
      ),
    );
  }
} // Constructor

@override
Widget build(BuildContext context) {
  // Get the list of predefined habits from our utility class
  final predefinedHabits = PredefinedHabits.getDefaultHabits();

  return Scaffold(
    appBar: AppBar(
      title: const Text('Choose a Habit'),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Predefined Habits',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Choose from our collection of popular habits or create your own.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two cards per row
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8, // Control card height relative to width
              ),
              itemCount: predefinedHabits.length,
              itemBuilder: (context, index) {
                final habit = predefinedHabits[index];
                return _buildHabitCard(context, habit);
              },
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        // Navigate to custom habit creation page
        // Navigator.pop(context, null);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HabitFormPage()),
        );
      },
      backgroundColor: Theme.of(context).colorScheme.secondary,
      foregroundColor: Theme.of(context).colorScheme.onSecondary,
      tooltip: 'Create custom habit',
      child: const Icon(Icons.add),
    ),
  );
}

// Build an individual habit card
Widget _buildHabitCard(BuildContext context, Habit habit) {
  // Convert string icon name to IconData
  // IconData iconData = Icons.bookmark;
  // try {
  //   // Try to find the icon by name
  //   iconData = IconData(
  //     // The following retrieves the codePoint for the icon
  //     // This is a simplified approach and might not work for all icons
  //     Icons.book.codePoint,
  //     fontFamily: 'MaterialIcons',
  //   );

  //   // This is a map of common icon names to their corresponding Icons
  //   final Map<String, IconData> iconMap = {
  //     'book': Icons.book,
  //     'alarm': Icons.alarm,
  //     'directions_run': Icons.directions_run,
  //     'code': Icons.code,
  //     'smoke_free': Icons.smoke_free,
  //     'self_improvement': Icons.self_improvement,
  //     'bookmark': Icons.bookmark,
  //   };

  //   Look up the icon in our map
  //   if (iconMap.containsKey(habit.icon)) {
  //     iconData = iconMap[habit.icon]!;
  //   }
  // } catch (e) {
  //   // Fallback to default icon if lookup fails
  //   iconData = Icons.bookmark;
  // }
  IconData iconData = habit.icon;
  // print(iconData);
  IconData badgeIcon =
      habit.nature == HabitNature.positive
          ? Icons.add_circle
          : Icons.remove_circle;

  // Get string representation of tracking frequency
  String frequencyText = _getFrequencyText(habit);

  return GestureDetector(
    onTap: () {
      // Return the selected habit to the previous screen
      Navigator.pop(context, habit);
    },
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [habit.color.withOpacity(0.7), habit.color],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with icon and badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  // backgroundColor: Colors.white.withOpacity(0.3),
                  child: Icon(iconData, color: Colors.white),
                ),
                Icon(
                  badgeIcon,
                  color:
                      habit.nature == HabitNature.positive
                          ? Colors.green[300]
                          : Colors.red[300],
                ),
              ],
            ),

            const Spacer(),

            // Habit title
            Text(
              habit.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Frequency text
            Text(
              frequencyText,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),

            const SizedBox(height: 8),

            // Target days
            Text(
              'Goal: ${habit.targetDays} days',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),

            const SizedBox(height: 4),

            // View details button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Show more details in a dialog
                    _showHabitDetails(context, habit);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                  ),
                  child: const Text(
                    'Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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

// Helper to get a readable frequency text
String _getFrequencyText(Habit habit) {
  switch (habit.trackingCategory) {
    case TrackingCategory.daily:
      return 'Every day';
    case TrackingCategory.custom:
      // For custom, show which days are tracked
      final days = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
      final selectedDays = <String>[];

      for (int i = 0; i < 7; i++) {
        if (habit.daysToTrack[i]) {
          selectedDays.add(days[i]);
        }
      }

      return selectedDays.join(', ');
  }
}

// Show a dialog with habit details - bottom right in the widget
void _showHabitDetails(BuildContext context, Habit habit) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(habit.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Type: ${habit.nature == HabitNature.positive ? 'Positive' : 'Negative'}',
              ),
              const SizedBox(height: 8),
              Text('Frequency: ${_getFrequencyText(habit)}'),
              const SizedBox(height: 8),
              Text('Target: ${habit.targetDays} days'),
              if (habit.notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Notes: ${habit.notes}'),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
            FilledButton(
              onPressed: () {
                // Close dialog and return to previous screen with this habit
                Navigator.pop(context);
                Navigator.pop(context, habit);
              },
              child: const Text('Select'),
            ),
          ],
        ),
  );
}
