// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, prefer_final_fields, unused_element, sort_child_properties_last, avoid_unnecessary_containers, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthup/features/auth/front/pages/login_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:healthup/constants/front_constants.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Map<String, dynamic>>> _events = {};

  TextEditingController _eventController = TextEditingController();
  Color _selectedColor = AppColors.thirdColor;
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _addEvent() async {
    if (_eventController.text.isEmpty) return;

    final event = {
      'name': _eventController.text,
      'color': _selectedColor.value,
      'time': _selectedTime.format(context),
    };

    setState(() {
      if (_events[_selectedDay] != null) {
        _events[_selectedDay]!.add(event);
      } else {
        _events[_selectedDay] = [event];
      }
    });

    _eventController.clear();
    Navigator.pop(context);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDay);

      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('dailyExercises')
          .doc(formattedDate)
          .set({
        'exercises': FieldValue.arrayUnion([event])
      }, SetOptions(merge: true));
    }
  }

  Future<void> _loadEventsFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('dailyExercises')
          .get()
          .then((snapshot) {
        Map<DateTime, List<Map<String, dynamic>>> loadedEvents = {};
        snapshot.docs.forEach((doc) {
          DateTime date = DateFormat('yyyy-MM-dd').parse(doc.id);
          List<dynamic> events = doc['exercises'];
          loadedEvents[date] = events
              .map((e) =>
                  {'name': e['name'], 'color': e['color'], 'time': e['time']})
              .toList();
        });
        setState(() {
          _events = loadedEvents;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    _loadEventsFromFirebase(); // Carregar eventos do Firebase ao inicializar a página
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondBackgroundColor,
        title:
            Text('Adicionar Exercício', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _eventController,
              decoration: InputDecoration(
                labelText: 'Nome do Exercício',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child!,
                    );
                  },
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      _selectedTime = value;
                    });
                  }
                });
              },
              child:
                  Text('Selecionar Horário: ${_selectedTime.format(context)}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                foregroundColor: Colors.white,
                minimumSize: Size(100, 40),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                textStyle: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              foregroundColor: Colors.white,
              minimumSize: Size(100, 40),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              textStyle: TextStyle(fontSize: 14),
            ),
          ),
          ElevatedButton(
            onPressed: _addEvent,
            child: Text('Adicionar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              foregroundColor: Colors.white,
              minimumSize: Size(100, 40),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              textStyle: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat.Hm('pt_BR');
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: AppColors.secondBackgroundColor,
          title: Text(
            'Calendário de Atividades',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ]),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 20,
              left: 10,
              right: 10,
            ),
            color: AppColors.backgroundColor,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.secondBackgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TableCalendar(
                locale: 'pt_BR',
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  weekendStyle: TextStyle(
                      color: AppColors.thirdColor, fontWeight: FontWeight.bold),
                ),
                headerStyle: HeaderStyle(
                  titleTextFormatter: (date, locale) => DateFormat.yMMMM(locale)
                      .format(date)
                      .replaceFirst(
                        DateFormat.yMMMM(locale).format(date)[0],
                        DateFormat.yMMMM(locale).format(date)[0].toUpperCase(),
                      ),
                  titleTextStyle: TextStyle(
                      color: AppColors.thirdColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  formatButtonVisible: false,
                  leftChevronIcon:
                      Icon(Icons.chevron_left, color: AppColors.thirdColor),
                  rightChevronIcon:
                      Icon(Icons.chevron_right, color: AppColors.thirdColor),
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  defaultTextStyle: TextStyle(color: Colors.white),
                  todayDecoration: BoxDecoration(
                    color: AppColors.thirdColor,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: AppColors.thirdColor,
                    shape: BoxShape.circle,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  // Construtor padrão para dias normais
                  defaultBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors
                                .transparent, // Cor da borda transparente para dias normais
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                  // Construtor para o dia de hoje
                  todayBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors
                                .white, // Cor da borda vermelha para o dia de hoje
                            width: 2.0, // Largura da borda
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                  // Construtor para o dia selecionado
                  selectedBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors
                                .thirdColor, // Cor da borda azul para o dia selecionado
                            width: 2.0, // Largura da borda
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
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
                eventLoader: (day) {
                  return _events[day] ?? [];
                },
              ),
            ),
          ),
          ...(_events[_selectedDay] ?? []).map((event) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(event['color']),
                ),
                title:
                    Text(event['name'], style: TextStyle(color: Colors.white)),
                subtitle:
                    Text(event['time'], style: TextStyle(color: Colors.white)),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        backgroundColor: AppColors.thirdColor,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.black,
    ),
    home: CalendarPage(),
  ));
}
