// ignore_for_file: use_super_parameters, prefer_const_constructors, avoid_print

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
      // Remover espaços em branco adicionais e caracteres invisíveis
      String cleanedTime =
          time12h.replaceAll(RegExp(r'[^\x20-\x7E]'), '').trim();

      // Formato de entrada: 12h (e.g., "02:30 PM")
      DateFormat format12h = DateFormat.jm(); // Formato 12h
      DateTime dateTime = format12h.parse(cleanedTime);

      // Formato de saída: 24h (e.g., "14:30")
      DateFormat format24h = DateFormat('HH:mm');
      return format24h.format(dateTime);
    } catch (e) {
      print('Erro ao converter o horário: $e');
      return time12h; // Retornar o horário original em caso de erro
    }
  }
}
