import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// Enum to define the nature of the habit
enum HabitNature { positive, negative }

// Enum to define the tracking frequency
enum TrackingCategory { daily, weekly, monthly, custom }

// Class to represent a single habit
class Habit {
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
  final String iconName;
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
    this.iconName = 'bookmark',
    this.color = Colors.blue,
  }) : id = id ?? const Uuid().v4(),
       startDate = startDate ?? DateTime.now(),
       completedDates = completedDates ?? [];

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
    String? iconName,
    Color? color,
  }) {
    return Habit(
      id: this.id,
      title: title ?? this.title,
      nature: nature ?? this.nature,
      trackingCategory: trackingCategory ?? this.trackingCategory,
      daysToTrack: daysToTrack ?? this.daysToTrack,
      targetDays: targetDays ?? this.targetDays,
      notes: notes ?? this.notes,
      reminderTime: reminderTime ?? this.reminderTime,
      startDate: this.startDate,
      completedDates: this.completedDates,
      iconName: iconName ?? this.iconName,
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
      iconName: iconName,
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
      iconName: iconName,
      color: color,
    );
  }

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
      'iconName': iconName,
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
      iconName: map['iconName'],
      color: Color(map['color']),
    );
  }
}

// Predefined habits for quick selection
class PredefinedHabits {
  static List<Habit> getDefaultHabits() {
    return [
      Habit(
        title: 'Read Books',
        nature: HabitNature.positive,
        trackingCategory: TrackingCategory.daily,
        targetDays: 30,
        iconName: 'book',
        color: Colors.amber,
      ),
      Habit(
        title: 'Wake Up Early',
        nature: HabitNature.positive,
        trackingCategory: TrackingCategory.daily,
        targetDays: 30,
        notes: 'Wake up before 6 AM',
        iconName: 'alarm',
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
        iconName: 'directions_run',
        color: Colors.green,
      ),
      Habit(
        title: 'Code Streak',
        nature: HabitNature.positive,
        trackingCategory: TrackingCategory.daily,
        targetDays: 100,
        iconName: 'code',
        color: Colors.blue,
      ),
      Habit(
        title: 'No Smoking',
        nature: HabitNature.negative,
        trackingCategory: TrackingCategory.daily,
        targetDays: 90,
        iconName: 'smoke_free',
        color: Colors.purple,
      ),
      Habit(
        title: 'Meditation',
        nature: HabitNature.positive,
        trackingCategory: TrackingCategory.daily,
        targetDays: 21,
        iconName: 'self_improvement',
        color: Colors.teal,
      ),
    ];
  }
}
