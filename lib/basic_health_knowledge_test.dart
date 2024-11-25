import 'package:flutter/material.dart';
import 'app_bar.dart';

class BasicHealthKnowledgeTestScreen extends StatefulWidget {
  final String testType;
  final String testLevel;
  final VoidCallback onCompleted;

  const BasicHealthKnowledgeTestScreen({
    super.key,
    required this.testType,
    required this.testLevel,
    required this.onCompleted,
  });

  @override
  _BasicHealthKnowledgeTestScreenState createState() =>
      _BasicHealthKnowledgeTestScreenState();
}

class _BasicHealthKnowledgeTestScreenState
    extends State<BasicHealthKnowledgeTestScreen> {
  int correctAnswers = 0;
  int currentQuestionIndex = 0;

  final List<Question> questions = [
    Question(
      questionText: '¿Qué es la fiebre?',
      choices: [
        'Dolor muscular',
        'Cansancio extremo',
        'Temperatura alta del cuerpo',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Cómo se transmite la gripe?',
      choices: [
        'Por contacto con superficies contaminadas',
        'Por el aire al toser o estornudar',
        'Por contacto con los ojos',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Qué es la hipertensión?',
      choices: [
        'Presión alta en las arterias',
        'Bajo nivel de oxígeno en la sangre',
        'Dificultad para respirar',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuál es un síntoma común de la deshidratación?',
      choices: [
        'Náuseas',
        'Sudoración excesiva',
        'Dolor de cabeza',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué debe hacer si se corta?',
      choices: [
        'Dejar que sangre para limpiarse',
        'Lavar la herida y aplicar un apósito',
        'Aplicar crema sin limpiar la herida',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Qué es la diabetes tipo 1?',
      choices: [
        'Enfermedad donde el cuerpo no produce insulina',
        'Enfermedad que causa hipertensión',
        'Enfermedad que afecta los pulmones',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es el colesterol alto?',
      choices: [
        'Un nivel bajo de glucosa en la sangre',
        'Un nivel bajo de proteínas en la sangre',
        'Un nivel elevado de grasa en la sangre',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué tipo de dieta se recomienda para prevenir enfermedades cardiovasculares?',
      choices: [
        'Dieta baja en grasas saturadas y sal',
        'Dieta alta en azúcares',
        'Dieta baja en proteínas',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es un ataque al corazón?',
      choices: [
        'Cuando la presión arterial baja demasiado',
        'Cuando el flujo de sangre al corazón se bloquea',
        'Cuando la respiración se detiene por completo',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Cuál es el principal riesgo de la obesidad?',
      choices: [
        'Falta de sueño',
        'Alergias frecuentes',
        'Problemas cardíacos y diabetes',
      ],
      correctAnswerIndex: 2,
    ),
  ];

  void nextQuestion(int selectedIndex) {
    if (selectedIndex == questions[currentQuestionIndex].correctAnswerIndex) {
      correctAnswers++;
    }

    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        widget.onCompleted();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                CompletionScreen(correctAnswers: correctAnswers),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, true),
      backgroundColor: const Color.fromARGB(255, 255, 251, 245),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'PREGUNTA ${currentQuestionIndex + 1}:',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                questions[currentQuestionIndex].questionText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Column(
                children: questions[currentQuestionIndex]
                    .choices
                    .asMap()
                    .entries
                    .map((entry) {
                  int index = entry.key;
                  String choice = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => nextQuestion(index),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        choice,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompletionScreen extends StatelessWidget {
  final int correctAnswers;

  const CompletionScreen({super.key, required this.correctAnswers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, false),
      backgroundColor: const Color.fromARGB(255, 255, 251, 245),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Has completado el test. ¡Gracias por tu participación!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Respuestas correctas: $correctAnswers/10',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16.0,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Finalizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Question {
  final String questionText;
  final List<String> choices;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.choices,
    required this.correctAnswerIndex,
  });
}