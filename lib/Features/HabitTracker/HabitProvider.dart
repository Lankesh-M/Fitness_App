import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HabitModel.dart';

class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  List<Habit> _deletedHabits = [];
  bool _isLoading = true;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;

  HabitProvider() {
    _loadHabits();
  }

  // Load habits from storage
  // Future<void> _loadHabits() async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final habitsJson = prefs.getStringList('habits') ?? [];

  //     _habits =
  //         habitsJson.map((json) => Habit.fromMap(jsonDecode(json))).toList();
  //   } catch (e) {
  //     debugPrint('Error loading habits: $e');
  //     _habits = [];
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }
  Future<void> _loadHabits() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final habitsJson = prefs.getStringList('habits') ?? [];

      _habits =
          habitsJson.map((json) => Habit.fromMap(jsonDecode(json))).toList();
      print("Loaded habits: $_habits"); // Debugging
    } catch (e) {
      debugPrint('Error loading habits: $e');
      _habits = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Save habits to storage
  // Future<void> _saveHabits() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final habitsJson =
  //         _habits.map((habit) => jsonEncode(habit.toMap())).toList();

  //     await prefs.setStringList('habits', habitsJson);
  //   } catch (e) {
  //     debugPrint('Error saving habits: $e');
  //   }
  // }
  Future<void> _saveHabits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final habitsJson =
          _habits.map((habit) => jsonEncode(habit.toMap())).toList();
      await prefs.setStringList('habits', habitsJson);

      print("Saved habits: $habitsJson"); // Debugging
    } catch (e) {
      debugPrint('Error saving habits: $e');
    }
  }

  // Add a new habit
  void addHabit(Habit habit) {
    _habits.add(habit);
    notifyListeners();
    _saveHabits();
  }

  // Update an existing habit
  void updateHabit(Habit updatedHabit) {
    final index = _habits.indexWhere((h) => h.id == updatedHabit.id);
    if (index != -1) {
      _habits[index] = updatedHabit;
      notifyListeners();
      _saveHabits();
    }
  }

  // // Delete a habit
  // void deleteHabit(String id) {
  //   _habits.removeWhere((habit) => habit.id == id);
  //   notifyListeners();
  //   _saveHabits();
  // }

  // Delete a habit

  void deleteHabit(String id) {
    final habit = _habits.firstWhere((habit) => habit.id == id);

    // if (habi) {
    _deletedHabits.add(habit); // Store deleted habit for possible restoration
    for (int i = 0; i < _deletedHabits.length; i++) {
      print("Item that is in here ${_deletedHabits[i].title}");
    }

    _habits.removeWhere((h) => h.id == id);
    notifyListeners();
    _saveHabits();
    // }
  }

  // Restore the last deleted habit
  // ToDo : Cant restore deleted habits fix it bro
  void restoreHabit() {
    print(" I am here please see me ${_deletedHabits.length}");
    if (_deletedHabits.isNotEmpty) {
      final habit = _deletedHabits.removeLast();
      _habits.add(habit);
      notifyListeners();
      _saveHabits();
    }
  }

  // Toggle completion status for today
  void toggleHabitCompletion(String id) {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      final habit = _habits[index];

      if (habit.isCompletedToday) {
        // Remove today's date from completed dates
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        _habits[index] = habit.removeCompletedDate(todayDate);
      } else {
        // Add today's date to completed dates
        _habits[index] = habit.addCompletedDate(DateTime.now());
      }

      notifyListeners();
      _saveHabits();
    }
  }

  // Get habits by category (positive/negative)
  List<Habit> getHabitsByNature(HabitNature nature) {
    return _habits.where((habit) => habit.nature == nature).toList();
  }

  // Get habits that should be tracked today
  List<Habit> getTodayHabits() {
    return _habits.where((habit) => habit.isTrackingDay).toList();
  }

  // Import predefined habits
  void importPredefinedHabits() {
    final predefinedHabits = PredefinedHabits.getDefaultHabits();

    for (final habit in predefinedHabits) {
      if (!_habits.any((h) => h.title == habit.title)) {
        _habits.add(habit);
      }
    }

    notifyListeners();
    _saveHabits();
  }
}
