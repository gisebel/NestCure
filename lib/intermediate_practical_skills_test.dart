import 'package:flutter/material.dart';
import 'app_bar.dart';

class IntermediatePracticalSkillsTestScreen extends StatefulWidget {
  final String testType;
  final String testLevel;
  final VoidCallback onCompleted;

  const IntermediatePracticalSkillsTestScreen({
    super.key,
    required this.testType,
    required this.testLevel,
    required this.onCompleted,
  });

  @override
  _IntermediatePracticalSkillsTestScreenState createState() =>
      _IntermediatePracticalSkillsTestScreenState();
}

class _IntermediatePracticalSkillsTestScreenState
    extends State<IntermediatePracticalSkillsTestScreen> {
  int correctAnswers = 0;
  int currentQuestionIndex = 0;

  final List<Question> questions = [
    Question(
      questionText:
          '¿Qué debe hacerse si una persona responde pero está experimentando dificultad para respirar?',
      choices: [
        'Dejar que se siente y respire lentamente.',
        'Realizar la maniobra de Heimlich.',
        'Animarla a toser para intentar despejar las vías respiratorias.',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Cuál es el propósito principal de las ventilaciones en la RCP?',
      choices: [
        'Mantener la circulación sanguínea.',
        'Saturar los pulmones con oxígeno.',
        'Prevenir la hipoventilación.',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText:
          '¿Cuál es el paso inicial para ayudar a una persona que está atragantada y no puede hablar ni toser?',
      choices: [
        'Realizar compresiones abdominales.',
        'Administrar ventilaciones.',
        'Realizar la maniobra de Heimlich.',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Cuál es la técnica adecuada para abrir las vías aéreas de una persona inconsciente?',
      choices: [
        'Inclinar la cabeza hacia atrás y elevar la barbilla.',
        'Girar la cabeza hacia un lado y levantar la barbilla.',
        'Presionar el abdomen en dirección opuesta al esternón.',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText:
          '¿Qué deberías hacer si te encuentras solo con una persona inconsciente que no está respirando?',
      choices: [
        'Llamar al número de emergencias y comenzar la RCP.',
        'Intentar mover a la persona a un lugar más seguro antes de iniciar la RCP.',
        'Administrar ventilaciones antes de las compresiones torácicas.',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuántas veces debes comprimir el pecho durante una serie de RCP en un adulto?',
      choices: [
        'Al menos 100 veces.',
        'Al menos 30 veces.',
        'Al menos 50 veces.',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText:
          '¿Cuál es la causa más común de obstrucción de las vías respiratorias en adultos que requiere la maniobra de Heimlich?',
      choices: [
        'Alimentos sólidos.',
        'Líquidos.',
        'Obstrucciones mecánicas.',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText:
          '¿Qué debe hacerse después de administrar las primeras compresiones torácicas en la RCP?',
      choices: [
        'Reevaluar las vías respiratorias.',
        'Administrar dos ventilaciones.',
        'Comprobar el pulso carotídeo.',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuál es la profundidad adecuada para las compresiones torácicas en un niño?',
      choices: [
        'Al menos 5 centímetros.',
        'Al menos 3 centímetros.',
        'Al menos 2 centímetros.',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText:
          '¿Qué posición debe tener el rescatador al administrar compresiones torácicas en un entorno no médico?',
      choices: [
        'De rodillas al lado de la persona.',
        'De pie detrás de la persona.',
        'Arrodillado frente a la persona.',
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