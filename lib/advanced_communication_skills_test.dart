import 'package:flutter/material.dart';
import 'package:nestcure/app_bar.dart';

class AdvancedCommunicationSkillsTestScreen extends StatefulWidget {
  final String testType;
  final String testLevel;
  final VoidCallback onCompleted;

  const AdvancedCommunicationSkillsTestScreen({
    super.key,
    required this.testType,
    required this.testLevel,
    required this.onCompleted,
  });

  @override
  _AdvancedCommunicationSkillsTestScreenState createState() =>
      _AdvancedCommunicationSkillsTestScreenState();
}

class _AdvancedCommunicationSkillsTestScreenState
    extends State<AdvancedCommunicationSkillsTestScreen> {
  int correctAnswers = 0;
  int currentQuestionIndex = 0;

  final List<Question> questions = [
    Question(
      questionText: '¿Qué es la comunicación asertiva?',
      choices: [
        'Evitar conflictos a toda costa',
        'Expresarse con confianza y respeto',
        'Ser agresivo para hacerse entender',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Cómo se puede fomentar la comunicación efectiva en un equipo?',
      choices: [
        'Compitiendo entre los miembros',
        'Ignorando las opiniones de los demás',
        'Promoviendo la colaboración y la retroalimentación abierta',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué es la comunicación intercultural efectiva?',
      choices: [
        'Adaptarse y respetar las diferentes culturas',
        'Asumir que todos entienden nuestra cultura',
        'Hablar solo en nuestra lengua',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es la escucha activa?',
      choices: [
        'Prestar atención y demostrar interés en lo que dice la otra persona',
        'Escuchar sin responder',
        'Juzgar rápidamente lo que dice el otro',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué significa la comunicación no verbal?',
      choices: [
        'Hablar sin palabras',
        'La transmisión de mensajes a través del lenguaje corporal y expresiones',
        'Escribir sin usar palabras',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Cuál es la principal barrera en la comunicación efectiva?',
      choices: [
        'Los prejuicios y estereotipos',
        'El uso de tecnología',
        'El ruido ambiente',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué característica tiene un buen feedback?',
      choices: [
        'Es confuso y general',
        'Es solo positivo, sin críticas',
        'Es claro, específico y constructivo',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Cómo se puede mejorar la empatía en la comunicación?',
      choices: [
        'Escuchando activamente y mostrando comprensión',
        'Imponiendo nuestra opinión sobre los demás',
        'Ignorando las emociones del otro',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué implica la comunicación persuasiva?',
      choices: [
        'Manipular a los demás para conseguir lo que queremos',
        'Convencer a los demás de forma ética y efectiva',
        'Imponer nuestras ideas sin considerar las de los demás',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Por qué es importante el tono de voz en la comunicación?',
      choices: [
        'Porque puede cambiar el significado del mensaje',
        'Porque es irrelevante en la mayoría de los casos',
        'Porque define la duración del mensaje',
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