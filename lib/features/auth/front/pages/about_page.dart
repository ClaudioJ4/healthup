// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:healthup/constants/front_constants.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sobre',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.secondBackgroundColor,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome do App',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'Health UP!',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Desenvolvedores',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'Cláudio José Dantas Gomes Confessor\nPedro Eduardo Morais Ribeiro da Silva\nCeres Germanna Braga Morais',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Objetivo do Aplicativo',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'O FitnessApp é projetado para ajudar os usuários a manterem uma vida fitness, fornecendo ferramentas para rastreamento de calorias, consumo de água e planejamento de atividades físicas.',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            _buildModuleSection(
              context,
              'Contador de Calorias',
              'Este módulo permite ao usuário adicionar refeições e calorias consumidas diariamente. O progresso é mostrado através de uma barra de progresso com uma meta estipulada pelo usuário.',
              'assets/caloriascount.png',
            ),
            _buildModuleSection(
              context,
              'Contador de Água',
              'O usuário pode adicionar manualmente a quantidade de água ingerida diariamente, com uma barra de progresso e uma meta diária.',
              'assets/aguacount.png',
            ),
            _buildModuleSection(
              context,
              'Calendário de Atividades',
              'Permite ao usuário marcar atividades físicas em um calendário, identificando-as com cores e assinalando quando foram concluídas.',
              'assets/calendario.png',
            ),
            _buildModuleSection(
              context,
              'Perfil',
              'Exibe o nome de usuário, email e um gráfico anual mostrando o total de calorias e água ingeridas mês a mês.',
              'assets/perfil.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleSection(BuildContext context, String title,
      String description, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 16),
        Center(
          child: Image.asset(imagePath),
        ),
        SizedBox(height: 32),
      ],
    );
  }
}
