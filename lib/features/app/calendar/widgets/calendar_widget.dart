// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields, library_private_types_in_public_api, prefer_const_constructors, unused_element, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'package:healthup/constants/front_constants.dart';

class ExerciseCalendarWidget extends StatefulWidget {
  @override
  _ExerciseCalendarWidgetState createState() => _ExerciseCalendarWidgetState();
}

class _ExerciseCalendarWidgetState extends State<ExerciseCalendarWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  TextEditingController _eventController = TextEditingController();
  Color _selectedColor = AppColors.thirdColor;

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    return Column(
      children: [
        TableCalendar(
          focusedDay: _focusedDay,
          firstDay: DateTime(2000),
          lastDay: DateTime(2100),
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          eventLoader: (day) {
            return eventProvider.getEventsForDay(day);
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              color: AppColors.thirdColor,
              fontSize: 16,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: AppColors.thirdColor,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: AppColors.thirdColor,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: Colors.white,
            ),
            weekendStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          calendarStyle: CalendarStyle(
            defaultTextStyle: TextStyle(color: Colors.white),
            todayTextStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            selectedTextStyle: TextStyle(
              color: Colors.white,
            ),
            weekendTextStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        ...eventProvider.getEventsForDay(_selectedDay).map(
              (event) => ListTile(
                title: Text(event.title),
                leading: CircleAvatar(
                  backgroundColor: event.color,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () =>
                      _showEditEventDialog(context, eventProvider, event),
                ),
              ),
            ),
      ],
    );
  }

  void _showAddEventDialog(BuildContext context, EventProvider eventProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adicionar Exercício'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _eventController,
              decoration: InputDecoration(labelText: 'Nome do Exercício'),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Cor:'),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _selectColor(context),
                  child: CircleAvatar(
                    backgroundColor: _selectedColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (_eventController.text.isEmpty) return;
              eventProvider.addEvent(
                _selectedDay,
                Event(_eventController.text, _selectedColor),
              );
              _eventController.clear();
              Navigator.of(context).pop();
            },
            child: Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  void _showEditEventDialog(
      BuildContext context, EventProvider eventProvider, Event event) {
    _eventController.text = event.title;
    _selectedColor = event.color;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Exercício'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _eventController,
              decoration: InputDecoration(labelText: 'Nome do Exercício'),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Cor:'),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _selectColor(context),
                  child: CircleAvatar(
                    backgroundColor: _selectedColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (_eventController.text.isEmpty) return;
              eventProvider.updateEvent(
                _selectedDay,
                event,
                Event(_eventController.text, _selectedColor),
              );
              _eventController.clear();
              Navigator.of(context).pop();
            },
            child: Text('Atualizar'),
          ),
        ],
      ),
    );
  }

  void _selectColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Selecionar Cor'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() {
                _selectedColor = color;
              });
            },
            availableColors: [
              Colors.red,
              Colors.green,
              Colors.blue,
              Colors.orange,
              Colors.purple,
              Colors.pink,
              Colors.teal,
              Colors.yellow,
              Colors.brown,
              Colors.cyan,
            ], // 10 cores diferentes
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Selecionar'),
          ),
        ],
      ),
    );
  }
}

class Event {
  final String title;
  final Color color;

  Event(this.title, this.color);
}

class EventProvider with ChangeNotifier {
  final Map<DateTime, List<Event>> _events = {};

  UnmodifiableListView<Event> getEventsForDay(DateTime day) {
    return UnmodifiableListView(_events[day] ?? []);
  }

  void addEvent(DateTime day, Event event) {
    if (_events[day] == null) {
      _events[day] = [];
    }
    _events[day]!.add(event);
    notifyListeners();
  }

  void updateEvent(DateTime day, Event oldEvent, Event newEvent) {
    final eventList = _events[day];
    if (eventList != null) {
      final index = eventList.indexOf(oldEvent);
      if (index != -1) {
        eventList[index] = newEvent;
        notifyListeners();
      }
    }
  }
}
