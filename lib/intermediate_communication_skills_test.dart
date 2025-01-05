import 'package:flutter/material.dart';
import 'app_bar.dart';

class IntermediateCommunicationSkillsTestScreen extends StatefulWidget {
  final String testType;
  final String testLevel;
  final Function(int) onCompleted;

  const IntermediateCommunicationSkillsTestScreen({
    super.key,
    required this.testType,
    required this.testLevel,
    required this.onCompleted,
  });

  @override
  _IntermediateCommunicationSkillsTestScreenState createState() =>
      _IntermediateCommunicationSkillsTestScreenState();
}

class _IntermediateCommunicationSkillsTestScreenState
    extends State<IntermediateCommunicationSkillsTestScreen> {
  int correctAnswers = 0;
  int currentQuestionIndex = 0;

  final List<Question> questions = [
    Question(
      questionText:
          '¿Cómo podemos asegurarnos de que hemos entendido correctamente el mensaje de alguien?',
      choices: [
        'Interrumpiendo para aclarar',
        'Reflejando y parafraseando lo que han dicho',
        'Respondiendo inmediatamente',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText:
          '¿Qué es importante tener en cuenta en la comunicación intercultural?',
      choices: [
        'Respetar las diferencias culturales',
        'Hablar solo en nuestro idioma',
        'Suponer que todos entienden nuestra cultura',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cómo podemos mejorar nuestra capacidad de escucha activa?',
      choices: [
        'Preparando nuestra respuesta mientras escuchamos',
        'Prestando toda nuestra atención al interlocutor',
        'Multitarea durante la conversación',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Cómo podemos demostrar empatía en una conversación?',
      choices: [
        'Reconociendo los sentimientos del otro',
        'Hablando más de nosotros mismos',
        'Interrumpiendo para dar consejos',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuál es una técnica para mejorar la comunicación en un grupo?',
      choices: [
        'Hablar todos a la vez',
        'Ignorar las aportaciones de los demás',
        'Establecer normas claras de comunicación',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué significa tener una comunicación clara y concisa?',
      choices: [
        'Expresarse de manera breve y fácil de entender',
        'Hablar muy rápido',
        'Usar palabras complicadas',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cómo podemos gestionar una conversación difícil?',
      choices: [
        'Elevando la voz para hacernos entender',
        'Manteniendo la calma y la objetividad',
        'Evitando el tema completamente',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Cómo podemos evitar malentendidos en la comunicación escrita?',
      choices: [
        'Usando muchas abreviaturas',
        'Escribiendo muy rápido',
        'Revisando y aclarando el mensaje',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué es el feedback constructivo?',
      choices: [
        'Comentarios positivos y sugerencias para mejorar',
        'Críticas negativas sin soluciones',
        'Ignorar los errores de los demás',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es importante para mantener una buena relación comunicativa?',
      choices: [
        'Hablar más que el otro',
        'Respetar y valorar la opinión del otro',
        'Estar de acuerdo en todo',
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