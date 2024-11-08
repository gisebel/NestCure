import 'package:flutter/material.dart';
import 'app_bar.dart';

class BasicCommunicationSkillsTestScreen extends StatefulWidget {
  final String testType;
  final String testLevel;
  final VoidCallback onCompleted;

  const BasicCommunicationSkillsTestScreen({
    super.key,
    required this.testType,
    required this.testLevel,
    required this.onCompleted,
  });

  @override
  _BasicCommunicationSkillsTestScreenState createState() =>
      _BasicCommunicationSkillsTestScreenState();
}

class _BasicCommunicationSkillsTestScreenState
    extends State<BasicCommunicationSkillsTestScreen> {
  int correctAnswers = 0;
  int currentQuestionIndex = 0;

  final List<Question> questions = [
    Question(
      questionText: '¿Cuál es la técnica de comunicación más efectiva?',
      choices: [
        'Hablar más alto',
        'Escucha activa',
        'Evitar el contacto visual'
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Cómo se puede mejorar la comunicación verbal?',
      choices: [
        'Hablando claramente y pausadamente',
        'Interrumpiendo constantemente',
        'Hablando muy rápido'
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es importante en la comunicación no verbal?',
      choices: [
        'Lenguaje corporal y expresión facial',
        'Hablar mucho',
        'Escribir correctamente'
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es la empatía en la comunicación?',
      choices: [
        'Estar de acuerdo con todo',
        'Hablar más de nosotros mismos',
        'Comprender y compartir los sentimientos de los demás',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Cómo se puede mejorar la comprensión en una conversación?',
      choices: [
        'Parafraseando lo que dice la otra persona',
        'Hablando más rápido',
        'Interrumpiendo a la otra persona'
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué significa mantener el contacto visual?',
      choices: [
        'Mirar hacia otro lado',
        'Mirar a los ojos del interlocutor',
        'Evitar la mirada'
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Cuál es una barrera común en la comunicación?',
      choices: [
        'Ruidos ambientales',
        'Escuchar activamente',
        'Hablar con claridad'
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cómo se puede mostrar interés durante una conversación?',
      choices: [
        'Mirando el móvil',
        'Hablando de otro tema',
        'Haciendo preguntas relevantes',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué es una comunicación asertiva?',
      choices: [
        'Evitar el conflicto',
        'Expresar las opiniones con respeto y firmeza',
        'Hablar sin parar'
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Cómo se puede mejorar la comunicación escrita?',
      choices: [
        'Utilizando un lenguaje claro y conciso',
        'Escribiendo largas parrafadas',
        'Utilizando muchas abreviaturas'
      ],
      correctAnswerIndex: 0,
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