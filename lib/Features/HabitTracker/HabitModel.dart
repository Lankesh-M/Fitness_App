import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// Enum to define the nature of the habit
enum HabitNature { positive, negative }

// Enum to define the tracking frequency
enum TrackingCategory { daily, custom }

// Class to represent a single habit
class Habit {
  // Defining class variable properites
  final String id;
  final String title;
  final HabitNature nature;
  final TrackingCategory trackingCategory;
  final List<bool> daysToTrack; // For custom days (7 days for a week)
  final int targetDays;
  final String notes;
  final TimeOfDay? reminderTime;
  final DateTime startDate;
  final List<DateTime> completedDates;
  final int iconCodePoint; // Storing IconData as an integer
  final Color color;

  // Constructor with required and optional parameters
  Habit({
    String? id,
    required this.title,
    required this.nature,
    required this.trackingCategory,
    this.daysToTrack = const [true, true, true, true, true, true, true],
    required this.targetDays,
    this.notes = '',
    this.reminderTime,
    DateTime? startDate,
    List<DateTime>? completedDates,
    required this.iconCodePoint, // Now stores IconData's codePoint
    this.color = Colors.blue,
  }) : id = id ?? const Uuid().v4(),
       startDate = startDate ?? DateTime.now(),
       completedDates = completedDates ?? [];

  factory Habit.empty() {
    return Habit(
      id: '',
      title: '',
      nature: HabitNature.positive,
      trackingCategory: TrackingCategory.daily,
      iconCodePoint: Icons.bookmark.codePoint,
      targetDays: 0,
    );
  }

  // Get current streak for daily habits
  int get currentStreak {
    if (completedDates.isEmpty) return 0;

    // Sort completed dates
    final sorted = List<DateTime>.from(completedDates)
      ..sort((a, b) => b.compareTo(a)); // Sort in descending order

    int streak = 1;
    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    yesterday = DateTime(yesterday.year, yesterday.month, yesterday.day);

    // If the most recent completion is not today or yesterday, check if today
    DateTime latestDate = DateTime(
      sorted[0].year,
      sorted[0].month,
      sorted[0].day,
    );
    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (latestDate != today && latestDate != yesterday) {
      //Break if a day is missed to do an habit
      return 0; // Streak broken
    }

    // Count consecutive days
    for (int i = 0; i < sorted.length - 1; i++) {
      DateTime current = DateTime(
        sorted[i].year,
        sorted[i].month,
        sorted[i].day,
      );
      DateTime next = DateTime(
        sorted[i + 1].year,
        sorted[i + 1].month,
        sorted[i + 1].day,
      );

      // Check if dates are consecutive
      final difference = current.difference(next).inDays;
      if (difference == 1) {
        streak++;
      } else {
        break; // Streak broken
      }
    }

    return streak;
  }

  // Check if habit is completed today
  bool get isCompletedToday {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    return completedDates.any(
      (date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
    );
  }

  // Calculate progress percentage
  double get progressPercentage {
    if (targetDays == 0) return 0.0;
    return (completedDates.length / targetDays).clamp(0.0, 1.0);
  }

  // Check if today is a tracking day (for custom category)
  bool get isTrackingDay {
    if (trackingCategory != TrackingCategory.custom) return true;
    final weekday = DateTime.now().weekday % 7; // 0 = Sunday, 1 = Monday, etc.
    return daysToTrack[weekday];
  }

  // Create a copy of the habit with updated fields
  Habit copyWith({
    String? title,
    HabitNature? nature,
    TrackingCategory? trackingCategory,
    List<bool>? daysToTrack,
    int? targetDays,
    String? notes,
    TimeOfDay? reminderTime,
    IconData? icon,
    Color? color,
  }) {
    return Habit(
      id: id,
      title: title ?? this.title,
      nature: nature ?? this.nature,
      trackingCategory: trackingCategory ?? this.trackingCategory,
      daysToTrack: daysToTrack ?? this.daysToTrack,
      targetDays: targetDays ?? this.targetDays,
      notes: notes ?? this.notes,
      reminderTime: reminderTime ?? this.reminderTime,
      startDate: startDate,
      completedDates: completedDates,
      iconCodePoint: iconCodePoint,
      color: color ?? this.color,
    );
  }

  // Add a completed date
  Habit addCompletedDate(DateTime date) {
    if (isCompletedToday) return this;

    final newCompletedDates = List<DateTime>.from(completedDates)..add(date);

    return Habit(
      id: id,
      title: title,
      nature: nature,
      trackingCategory: trackingCategory,
      daysToTrack: daysToTrack,
      targetDays: targetDays,
      notes: notes,
      reminderTime: reminderTime,
      startDate: startDate,
      completedDates: newCompletedDates,
      iconCodePoint: iconCodePoint,
      color: color,
    );
  }

  // Remove a completed date
  Habit removeCompletedDate(DateTime date) {
    final newCompletedDates = List<DateTime>.from(completedDates)..removeWhere(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );

    return Habit(
      id: id,
      title: title,
      nature: nature,
      trackingCategory: trackingCategory,
      daysToTrack: daysToTrack,
      targetDays: targetDays,
      notes: notes,
      reminderTime: reminderTime,
      startDate: startDate,
      completedDates: newCompletedDates,
      iconCodePoint: iconCodePoint,
      color: color,
    );
  }

  // Retrieve IconData from codePoint
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  // Convert Habit to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'nature': nature.index,
      'trackingCategory': trackingCategory.index,
      'daysToTrack': daysToTrack,
      'targetDays': targetDays,
      'notes': notes,
      'reminderTime':
          reminderTime != null
              ? '${reminderTime!.hour}:${reminderTime!.minute}'
              : null,
      'startDate': startDate.millisecondsSinceEpoch,
      'completedDates':
          completedDates.map((date) => date.millisecondsSinceEpoch).toList(),
      'iconCodePoint': iconCodePoint, // Store as integer
      'color': color.value,
    };
  }

  // Create Habit from Map
  factory Habit.fromMap(Map<String, dynamic> map) {
    TimeOfDay? reminder;
    if (map['reminderTime'] != null) {
      final parts = map['reminderTime'].split(':');
      reminder = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    return Habit(
      id: map['id'],
      title: map['title'],
      nature: HabitNature.values[map['nature']],
      trackingCategory: TrackingCategory.values[map['trackingCategory']],
      daysToTrack: List<bool>.from(map['daysToTrack']),
      targetDays: map['targetDays'],
      notes: map['notes'],
      reminderTime: reminder,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      completedDates:
          (map['completedDates'] as List)
              .map(
                (timestamp) => DateTime.fromMillisecondsSinceEpoch(timestamp),
              )
              .toList(),
      iconCodePoint: map['iconCodePoint'], // Retrieve integer
      color: Color(map['color']),
    );
  }
}
// Convert iconCodePoint back to IconData when needed

// Predefined habits for quick selection
class PredefinedHabits {
  static List<Habit> getDefaultHabits() {
    return [
      Habit(
        title: 'Read Books',
        nature: HabitNature.positive,
        trackingCategory: TrackingCategory.daily,
        targetDays: 30,
        notes: "Start reading atleast 10 pages every day",
        iconCodePoint: Icons.book.codePoint,
        color: Colors.amber,
      ),
      Habit(
        title: 'Wake Up Early',
        nature: HabitNature.positive,
        trackingCategory: TrackingCategory.daily,
        targetDays: 30,
        notes: 'Wake up before 6 AM',
        iconCodePoint: Icons.alarm.codePoint,
        color: Colors.red,
      ),
      Habit(
        title: 'Running',
        nature: HabitNature.positive,
        trackingCategory: TrackingCategory.custom,
        daysToTrack: [
          false,
          true,
          false,
          true,
          false,
          true,
          false,
        ], // Mon, Wed, Fri
        targetDays: 12,
        notes: "Running improves your Cardiovascular Health",
        iconCodePoint: Icons.directions_run.codePoint,
        color: Colors.green,
      ),
      Habit(
        title: 'Code Streak',
        nature: HabitNature.positive,
        trackingCategory: TrackingCategory.daily,
        targetDays: 100,
        notes: "Consistency is the Key to Success",
        iconCodePoint: Icons.code.codePoint,
        color: Colors.blue,
      ),
      Habit(
        title: 'Protein Intake',
        nature: HabitNature.positive,
        trackingCategory: TrackingCategory.daily,
        targetDays: 90,
        notes: "Eat protein rich foods",
        iconCodePoint: Icons.fitness_center.codePoint,
        color: Colors.blue,
      ),
      Habit(
        title: 'Drink More Water',
        nature: HabitNature.positive,
        trackingCategory: TrackingCategory.daily,
        targetDays: 30,
        notes: "Drink Minimum 4 litres of water every day",
        iconCodePoint: Icons.local_cafe.codePoint,
        color: Colors.lightBlue,
      ),
      Habit(
        title: 'No Drugs',
        nature: HabitNature.negative,
        trackingCategory: TrackingCategory.daily,
        targetDays: 90,
        notes: "Smoking is injurious to Health",
        iconCodePoint: Icons.smoke_free.codePoint,
        color: Colors.purple,
      ),
      Habit(
        title: 'Meditation',
        nature: HabitNature.positive,
        trackingCategory: TrackingCategory.daily,
        targetDays: 21,
        notes: "Medidate atleast 10 mins a day",
        iconCodePoint: Icons.self_improvement.codePoint,
        color: Colors.teal,
      ),
    ];
  }
}

// factory Habit.empty() => Habit(id: '', title: '', nature: HabitNature.positive, ...);
