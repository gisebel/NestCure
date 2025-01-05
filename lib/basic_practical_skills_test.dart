import 'package:flutter/material.dart';
import 'app_bar.dart';

class BasicPracticalSkillsTestScreen extends StatefulWidget {
  final String testType;
  final String testLevel;
  final Function(int) onCompleted;

  const BasicPracticalSkillsTestScreen({
    super.key,
    required this.testType,
    required this.testLevel,
    required this.onCompleted,
  });

  @override
  _BasicPracticalSkillsTestScreenState createState() =>
      _BasicPracticalSkillsTestScreenState();
}

class _BasicPracticalSkillsTestScreenState
    extends State<BasicPracticalSkillsTestScreen> {
  int correctAnswers = 0;
  int currentQuestionIndex = 0;

  final List<Question> questions = [
    Question(
      questionText: '¿Qué acción debes tomar primero en caso de presenciar a alguien desmayado en el suelo?',
      choices: [
        'Llamar al número de emergencias.',
        'Sacudir a la persona para despertarla.',
        'Verificar la respiración y la conciencia.',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuál es la posición adecuada para colocar a una persona inconsciente que respira normalmente?',
      choices: [
        'Sentada con la cabeza inclinada hacia atrás.',
        'Boca arriba con las piernas levantadas.',
        'De lado, en posición de recuperación.',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué se debe hacer después de confirmar que una persona no responde y no respira normalmente?',
      choices: [
        'Realizar compresiones torácicas.',
        'Administrar agua para ayudar en la respiración.',
        'Darle palmadas en la espalda.',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuál es el ritmo recomendado para las compresiones torácicas durante la RCP?',
      choices: [
        '80-100 compresiones por minuto',
        '100-120 compresiones por minuto',
        '120-140 compresiones por minuto',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Cuál es la ubicación correcta para realizar las compresiones torácicas en un adulto?',
      choices: [
        'En el centro del pecho, entre los pezones.',
        'En la parte inferior del esternón.',
        'En la parte superior del abdomen.',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuál es la profundidad adecuada para las compresiones torácicas en un adulto?',
      choices: [
        'Al menos 2 centímetros.',
        'Al menos 10 centímetros.',
        'Al menos 5 centímetros.',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Cuál es el siguiente paso después de asegurar que las vías respiratorias están despejadas?',
      choices: [
        'Evaluar el pulso.',
        'Comenzar las compresiones torácicas.',
        'Iniciar la respiración artificial.',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Cuál es la secuencia correcta para administrar RCP básica a un adulto?',
      choices: [
        'Compresiones torácicas -> Apertura de las vías aéreas -> Ventilaciones.',
        'Ventilaciones -> Compresiones torácicas -> Apertura de las vías aéreas.',
        'Apertura de las vías aéreas -> Compresiones torácicas -> Ventilaciones.',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuántas ventilaciones deben administrarse por cada serie de compresiones torácicas en la RCP básica?',
      choices: [
        '5 ventilaciones.',
        '2 ventilaciones.',
        '1 ventilación.',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Cuál es la posición adecuada para realizar las compresiones torácicas en un bebé?',
      choices: [
        'En el centro del pecho, entre los pezones.',
        'En el estómago, justo debajo del ombligo.',
        'En la parte inferior del esternón.',
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