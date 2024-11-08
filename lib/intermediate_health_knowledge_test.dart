import 'package:flutter/material.dart';
import 'app_bar.dart';

class IntermediateHealthKnowledgeTestScreen extends StatefulWidget {
  final String testType;
  final String testLevel;
  final VoidCallback onCompleted;

  const IntermediateHealthKnowledgeTestScreen({
    super.key,
    required this.testType,
    required this.testLevel,
    required this.onCompleted,
  });

  @override
  _IntermediateHealthKnowledgeTestScreenState createState() =>
      _IntermediateHealthKnowledgeTestScreenState();
}

class _IntermediateHealthKnowledgeTestScreenState
    extends State<IntermediateHealthKnowledgeTestScreen> {
  int correctAnswers = 0;
  int currentQuestionIndex = 0;

  final List<Question> questions = [
    Question(
      questionText: '¿Qué es la arritmia?',
      choices: [
        'Alta presión sanguínea',
        'Latidos irregulares del corazón',
        'Dolor torácico',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Cómo se puede identificar un ictus?',
      choices: [
        'Debilidad facial y dificultad para hablar',
        'Dolor abdominal',
        'Dolor lumbar',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es una anafilaxia?',
      choices: [
        'Reacción alérgica grave',
        'Infección viral',
        'Trastorno mental',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cómo se puede tratar una picadura de abeja?',
      choices: [
        'Aplicar calor',
        'Utilizar alcohol',
        'Retirar el aguijón y aplicar frío',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué tipo de herida necesita puntos de sutura?',
      choices: [
        'Herida profunda y abierta',
        'Herida pequeña y superficial',
        'Rascadura leve',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es la hipoglucemia?',
      choices: [
        'Bajo nivel de azúcar en sangre',
        'Alto nivel de azúcar en sangre',
        'Alto nivel de colesterol',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué significa BLS en atención médica?',
      choices: [
        'Soporte Vital Avanzado',
        'Sistema de Vida Básica',
        'Soporte Vital Básico',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Cómo se trata una fractura ósea?',
      choices: [
        'Inmovilizar y buscar atención médica',
        'Aplicar calor',
        'Hacer masajes en la zona',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es la asistolia?',
      choices: [
        'Ritmo cardíaco lento',
        'Ausencia de actividad eléctrica en el corazón',
        'Contracciones ventriculares prematuras',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Cuál es el primer paso en la reanimación cardiopulmonar (RCP)?',
      choices: [
        'Comenzar compresiones torácicas',
        'Verificar si la persona responde',
        'Dar respiraciones artificiales',
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