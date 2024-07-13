// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields, library_private_types_in_public_api, prefer_const_constructors, unused_element, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthup/features/auth/front/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:healthup/constants/front_constants.dart';
import 'package:healthup/features/app/calendar/widgets/calendar_widget.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventProvider(),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.secondBackgroundColor,
            title: Text(
              'Calendário de Exercícios',
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            // Título da AppBar
            actions: [
              IconButton(
                icon: Icon(Icons.logout), // Ícone de logout
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
        body: Container(
          color: AppColors.backgroundColor,
          child: ExerciseCalendarWidget(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddEventDialog(context);
          },
          backgroundColor: AppColors.thirdColor,
          tooltip: 'Adicionar Exercício',
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    TextEditingController _eventController = TextEditingController();
    Color _selectedColor = AppColors.thirdColor;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.secondBackgroundColor,
              title: Text(
                'Adicionar Exercício',
                style: TextStyle(color: Colors.white),
              ),
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
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Cor:', style: TextStyle(color: Colors.white)),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          _selectColor(context, _selectedColor, (Color color) {
                            setState(() {
                              _selectedColor = color;
                            });
                          });
                        },
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
                  child:
                      Text('Cancelar', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    if (_eventController.text.isEmpty) return;

                    Provider.of<EventProvider>(context, listen: false).addEvent(
                      DateTime.now(),
                      Event(_eventController.text, _selectedColor),
                    );

                    _eventController.clear();
                    Navigator.of(context).pop();
                  },
                  child:
                      Text('Adicionar', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _selectColor(BuildContext context, Color currentColor,
      Function(Color) onColorSelected) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Selecionar Cor', style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.secondBackgroundColor,
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: currentColor,
              onColorChanged: onColorSelected,
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Selecionar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
