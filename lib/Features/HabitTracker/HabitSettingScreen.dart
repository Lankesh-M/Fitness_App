// habit_form_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/constants.dart';
import 'HabitModel.dart';
import 'HabitProvider.dart';

class HabitFormPage extends StatefulWidget {
  final Habit? habit; // Null for new habit, non-null for editing

  const HabitFormPage({Key? key, this.habit}) : super(key: key);

  @override
  _HabitFormPageState createState() => _HabitFormPageState();
}

class _HabitFormPageState extends State<HabitFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  late TextEditingController _targetDaysController;
  HabitNature _nature = HabitNature.positive;
  TrackingCategory _trackingCategory = TrackingCategory.daily;
  List<bool> _daysToTrack = List.filled(7, true);
  TimeOfDay? _reminderTime;
  IconData _iconName = Icons.bookmark;
  Color _selectedColor = Colors.blue;

  final List<Color> _colorOptions = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];
  // final List<Icon> _iconOptions = [];
  final List<Map<String, String>> _iconOptions = [
    {'name': 'book', 'label': 'Book'},
    {'name': 'directions_run', 'label': 'Running'},
    {'name': 'fitness_center', 'label': 'Fitness'},
    {'name': 'health_and_safety', 'label': 'Health'},
    {'name': 'code', 'label': 'Code'},
    {'name': 'self_improvement', 'label': 'Meditation'},
    {'name': 'alarm', 'label': 'Alarm'},
    {'name': 'smoke_free', 'label': 'No Drugs'},
    {'name': 'phone_android', 'label': 'Phone'},
    {'name': 'brush', 'label': 'Art'},
    {'name': 'music_note', 'label': 'Music'},
    {'name': 'restaurant', 'label': 'Diet'},
    {'name': 'create', 'label': 'Journal'},
    {'name': 'bookmark', 'label': 'General'},
  ];

  final Map<String, IconData> IconsMap = {
    'book': Icons.book,
    'directions_run': Icons.directions_run,
    'health_and_safety': Icons.health_and_safety,
    'fitness_center': Icons.fitness_center,
    'code': Icons.code,
    'local_cafe': Icons.local_cafe,
    'self_improvement': Icons.self_improvement,
    'alarm': Icons.alarm,
    'smoke_free': Icons.smoke_free,
    'phone_android': Icons.phone_android,
    'brush': Icons.brush,
    'music_note': Icons.music_note,
    'restaurant': Icons.restaurant,
    'create': Icons.create,
    'pets': Icons.pets,
    'bookmark': Icons.bookmark,
  };

  @override
  void initState() {
    super.initState();

    // Initialize controllers and values
    _titleController = TextEditingController(text: widget.habit?.title ?? '');
    _notesController = TextEditingController(text: widget.habit?.notes ?? '');
    _targetDaysController = TextEditingController(
      text: (widget.habit?.targetDays ?? 21).toString(),
    );

    if (widget.habit != null) {
      _nature = widget.habit!.nature;
      _trackingCategory = widget.habit!.trackingCategory;
      _daysToTrack = List.from(widget.habit!.daysToTrack);
      _reminderTime = widget.habit!.reminderTime;
      _iconName = widget.habit!.icon;
      _selectedColor = widget.habit!.color;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _targetDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.habit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Habit' : 'Create New Habit'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Habit Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Nature selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nature of the Habit',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<HabitNature>(
                      segments: const [
                        ButtonSegment(
                          value: HabitNature.positive,
                          label: Text('Positive'),
                          icon: Icon(Icons.add_circle_outline),
                        ),
                        ButtonSegment(
                          value: HabitNature.negative,
                          label: Text('Negative'),
                          icon: Icon(Icons.remove_circle_outline),
                        ),
                      ],
                      selected: {_nature},
                      onSelectionChanged: (Set<HabitNature> newSelection) {
                        setState(() {
                          _nature = newSelection.first;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tracking category
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tracking Frequency',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<TrackingCategory>(
                      value: _trackingCategory,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: TrackingCategory.daily,
                          child: Text('Daily (Streak)'),
                        ),

                        DropdownMenuItem(
                          value: TrackingCategory.custom,
                          child: Text('Custom Days'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _trackingCategory = value!;
                        });
                      },
                    ),

                    // Show day selection if custom tracking is selected
                    if (_trackingCategory == TrackingCategory.custom)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select Days',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ToggleButtons(
                              direction: Axis.horizontal,
                              onPressed: (int index) {
                                setState(() {
                                  _daysToTrack[index] = !_daysToTrack[index];
                                });
                              },
                              borderRadius: BorderRadius.circular(8.0),
                              isSelected: _daysToTrack,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Text('S'),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Text('M'),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Text('T'),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Text('W'),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Text('T'),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Text('F'),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Text('S'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Target days field
            TextFormField(
              controller: _targetDaysController,
              decoration: const InputDecoration(
                labelText: 'Number of Days to Follow Habit',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter number of days';
                }
                if (int.tryParse(value) == null || int.parse(value) <= 0) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Notes field
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes about the Habit',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Reminder time
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reminder Notification',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title: Text(
                        _reminderTime == null
                            ? 'No reminder set'
                            : 'Reminder at ${_reminderTime!.format(context)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_reminderTime != null)
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  _reminderTime = null;
                                });
                              },
                            ),
                          IconButton(
                            icon: const Icon(Icons.alarm),
                            onPressed: () async {
                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: _reminderTime ?? TimeOfDay.now(),
                              );
                              if (time != null) {
                                setState(() {
                                  _reminderTime = time;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Icon selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choose an Icon',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                          _iconOptions.map((option) {
                            var iconData = IconsMap[option['name']]!;
                            final isSelected = _iconName == iconData;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _iconName = iconData;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? _selectedColor.withOpacity(0.2)
                                          : null,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? _selectedColor
                                            : Colors.grey,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      iconData,
                                      // Icon(
                                      //   Icons.abc,
                                      color:
                                          isSelected
                                              ? _selectedColor
                                              : Colors.grey,
                                    ),
                                    Text(
                                      option['label']!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            isSelected
                                                ? _selectedColor
                                                : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Color selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choose a Color',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                          _colorOptions.map((color) {
                            final isSelected = _selectedColor == color;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedColor = color;
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow:
                                      isSelected
                                          ? [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                          : null,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit button
            FilledButton.icon(
              onPressed: _saveHabit,
              icon: Icon(isEditing ? Icons.save : Icons.add),
              label: Text(isEditing ? 'Save Changes' : 'Create Habit'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      final habitProvider = Provider.of<HabitProvider>(context, listen: false);

      final habit = Habit(
        id: widget.habit?.id,
        title: _titleController.text,
        nature: _nature,
        trackingCategory: _trackingCategory,
        daysToTrack: _daysToTrack,
        targetDays: int.parse(_targetDaysController.text),
        notes: _notesController.text,
        reminderTime: _reminderTime,
        startDate: widget.habit?.startDate,
        completedDates: widget.habit?.completedDates,
        iconCodePoint: _iconName.codePoint, //Todo : change here
        color: _selectedColor,
      );

      if (widget.habit == null) {
        habitProvider.addHabit(habit);
      } else {
        habitProvider.updateHabit(habit);
      }

      Navigator.pop(context);
    }
  }
}
