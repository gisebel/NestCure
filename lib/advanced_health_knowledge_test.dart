import 'package:flutter/material.dart';
import 'app_bar.dart';

class AdvancedHealthKnowledgeTestScreen extends StatefulWidget {
  final String testType;
  final String testLevel;
  final Function(int) onCompleted;

  const AdvancedHealthKnowledgeTestScreen({
    super.key,
    required this.testType,
    required this.testLevel,
    required this.onCompleted,
  });

  @override
  _AdvancedHealthKnowledgeTestScreenState createState() =>
      _AdvancedHealthKnowledgeTestScreenState();
}

class _AdvancedHealthKnowledgeTestScreenState
    extends State<AdvancedHealthKnowledgeTestScreen> {
  int correctAnswers = 0;
  int currentQuestionIndex = 0;

  final List<Question> questions = [
    Question(
      questionText: '¿Qué es el edema pulmonar?',
      choices: [
        'Acumulación de líquido en los pulmones',
        'Infección bacteriana de los pulmones',
        'Cáncer de pulmón',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuál es el tratamiento inicial para un infarto agudo de miocardio?',
      choices: [
        'Dar bebidas calientes',
        'Administrar aspirina',
        'Aplicar hielo',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Qué es un neumotórax?',
      choices: [
        'Presencia de aire en la cavidad pleural',
        'Inflamación de la pleura',
        'Infección pulmonar grave',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué medicamento se usa comúnmente para tratar la diabetes tipo 2?',
      choices: [
        'Metformina',
        'Insulina',
        'Amoxicilina',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuál es un síntoma común de la insuficiencia cardíaca congestiva?',
      choices: [
        'Dolor de cabeza',
        'Dificultad para respirar',
        'Dolor de garganta',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Qué es la bradicardia?',
      choices: [
        'Ritmo cardíaco rápido',
        'Ausencia de ritmo cardíaco',
        'Ritmo cardíaco anormalmente lento',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Cuál es el objetivo principal de la terapia con anticoagulantes?',
      choices: [
        'Prevenir la formación de coágulos',
        'Reducir el dolor',
        'Aumentar la presión sanguínea',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es la fibrilación auricular?',
      choices: [
        'Ritmo cardíaco lento y regular',
        'Ausencia de ritmo cardíaco',
        'Ritmo cardíaco rápido e irregular',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué es la septicemia?',
      choices: [
        'Infección generalizada en la sangre',
        'Infección localizada en la piel',
        'Inflamación de los ganglios linfáticos',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuál es el efecto secundario más común de los inhibidores de la ECA?',
      choices: [
        'Náuseas',
        'Tos seca',
        'Mareos',
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
      appBar: customAppBar(context, true),
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