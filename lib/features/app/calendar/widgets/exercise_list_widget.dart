// ignore_for_file: use_super_parameters, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ExerciseList extends StatelessWidget {
  final String userId;

  const ExerciseList({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(today);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dailyExercises')
          .doc(formattedDate)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(
            child: Text(
              'No exercises scheduled for today',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        List exercises = snapshot.data!['exercises'] ?? [];

        return Column(
          children: exercises.map<Widget>((event) {
            // Converter o horário do formato 12h para 24h
            String time24h = _convertTo24HourFormat(event['time']);

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(event['color']),
              ),
              title: Text(event['name'], style: TextStyle(color: Colors.white)),
              subtitle: Text(time24h, style: TextStyle(color: Colors.white)),
            );
          }).toList(),
        );
      },
    );
  }

  String _convertTo24HourFormat(String time12h) {
    try {
      // Remover espaços em branco extras
      time12h = time12h.trim();

      // Tratar alguns casos específicos como "12:00 AM" e "12:00 PM"
      if (time12h.endsWith(' AM') || time12h.endsWith(' PM')) {
        time12h =
            time12h.substring(0, time12h.length - 3); // Remover " AM" ou " PM"
      }

      // Converter para maiúsculas para garantir que AM/PM esteja em maiúsculas
      time12h = time12h.toUpperCase();

      // Remover caracteres não numéricos, exceto ":" e "AM/PM"
      time12h = time12h.replaceAll(RegExp(r'[^0-9:APM]+'), '');

      // Criar um DateFormat para parsear o horário de 12h
      DateFormat format12h = DateFormat('h:mm a');
      DateTime dateTime = format12h.parse(time12h);

      // Criar um DateFormat para formatar o horário para 24h
      DateFormat format24h = DateFormat('HH:mm');
      String formattedTime = format24h.format(dateTime);

      return formattedTime;
    } catch (e) {
      print('Erro ao converter o horário: $e');
      return time12h; // Retornar o horário original em caso de erro
    }
  }
}
