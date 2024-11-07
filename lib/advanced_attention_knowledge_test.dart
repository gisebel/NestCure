import 'package:flutter/material.dart';
import 'app_bar.dart';

class AdvancedAttentionKnowledgeTestScreen extends StatefulWidget {
  final String testType;
  final String testLevel;
  final VoidCallback onCompleted;

  const AdvancedAttentionKnowledgeTestScreen({
    super.key,
    required this.testType,
    required this.testLevel,
    required this.onCompleted,
  });

  @override
  _AdvancedAttentionKnowledgeTestScreenState createState() =>
      _AdvancedAttentionKnowledgeTestScreenState();
}

class _AdvancedAttentionKnowledgeTestScreenState
    extends State<AdvancedAttentionKnowledgeTestScreen> {
  int correctAnswers = 0;
  int currentQuestionIndex = 0;

  final List<Question> questions = [
    Question(
      questionText: '¿Cuál es la diferencia principal entre atención urgente y emergente?',
      choices: [
        'La atención urgente no es vital, la emergente es crítica',
        'La atención urgente es inmediata, la emergente puede esperar',
        'La atención urgente se da en casa, la emergente en el hospital',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuál es el objetivo de la atención paliativa?',
      choices: [
        'Mejorar la calidad de vida en enfermedades graves',
        'Curar enfermedades crónicas',
        'Proporcionar cuidados intensivos',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es la continuidad asistencial?',
      choices: [
        'Atender solo consultas urgentes',
        'Hacer un único tratamiento completo',
        'Proporcionar atención consistente y coordinada a lo largo del tiempo',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué es un plan de cuidados individualizado?',
      choices: [
        'Plan de tratamiento específico para un paciente',
        'Manual general de cuidados',
        'Protocolo de emergencias',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuál es la función de un gestor de casos?',
      choices: [
        'Coordinar atención para pacientes con necesidades complejas',
        'Administrar medicamentos',
        'Realizar intervenciones quirúrgicas',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es una unidad de cuidados intensivos?',
      choices: [
        'Centro de atención primaria',
        'Área hospitalaria para pacientes críticos',
        'Departamento de fisioterapia',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Qué es una visita de seguimiento?',
      choices: [
        'Consulta posterior para revisar el estado del paciente',
        'Primera consulta médica',
        'Consulta de urgencia',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es una consulta a distancia?',
      choices: [
        'Atención médica proporcionada por teléfono o internet',
        'Visita médica presencial',
        'Consulta de emergencia',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es un programa de rehabilitación?',
      choices: [
        'Pruebas diagnósticas',
        'Procedimientos quirúrgicos',
        'Programas para recuperar la funcionalidad después de una enfermedad o lesión',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué es una unidad de salud mental?',
      choices: [
        'Departamento que trata trastornos mentales',
        'Servicio de urgencias',
        'Laboratorio médico',
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
      body: Center( // Centrado del contenido final
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
                      fontSize: 16.0, // Texto más pequeño
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