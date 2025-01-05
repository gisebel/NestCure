import 'package:flutter/material.dart';
import 'app_bar.dart';

class BasicAttentionKnowledgeTestScreen extends StatefulWidget {
  final String testType;
  final String testLevel;
  final Function(int) onCompleted;

  const BasicAttentionKnowledgeTestScreen({
    super.key,
    required this.testType,
    required this.testLevel,
    required this.onCompleted,
  });

  @override
  _BasicAttentionKnowledgeTestScreenState createState() =>
      _BasicAttentionKnowledgeTestScreenState();
}

class _BasicAttentionKnowledgeTestScreenState
    extends State<BasicAttentionKnowledgeTestScreen> {
  int correctAnswers = 0;
  int currentQuestionIndex = 0;

  final List<Question> questions = [
    Question(
      questionText: '¿Qué es la atención primaria?',
      choices: [
        'Atención médica especializada',
        'Atención médica inicial',
        'Atención médica de emergencia',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Qué es una visita domiciliaria?',
      choices: [
        'Una visita a casa del paciente',
        'Una visita al hospital',
        'Una consulta telefónica',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué profesional realiza el seguimiento en la atención primaria?',
      choices: [
        'Cirujano',
        'Especialista',
        'Médico de familia',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué es un centro de salud?',
      choices: [
        'Un lugar donde se proporciona atención médica básica',
        'Un hospital grande',
        'Un laboratorio médico',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuál es el objetivo principal de la atención primaria?',
      choices: [
        'Prevenir y tratar enfermedades comunes',
        'Realizar cirugías complejas',
        'Atender emergencias críticas',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es una consulta programada?',
      choices: [
        'Una visita sin cita previa',
        'Una visita por emergencia',
        'Una visita médica con cita previa',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué es una consulta de urgencias?',
      choices: [
        'Una visita de seguimiento',
        'Una visita rutinaria',
        'Una visita médica para problemas inmediatos',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué es un historial médico?',
      choices: [
        'Un registro de la salud del paciente',
        'Un libro de medicina',
        'Una receta médica',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es una derivación médica?',
      choices: [
        'Enviar un paciente a un especialista',
        'Proporcionar una receta',
        'Realizar una prueba diagnóstica',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es un médico generalista?',
      choices: [
        'Un médico especializado en un campo',
        'Un médico que trata diversas enfermedades comunes',
        'Un médico de urgencias',
      ],
      correctAnswerIndex: 1,
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
        widget.onCompleted(correctAnswers);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CompletionScreen(correctAnswers: correctAnswers),
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
              SizedBox(height: 16),
              Text(
                questions[currentQuestionIndex].questionText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
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
      body: Center(
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