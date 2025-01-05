import 'package:flutter/material.dart';
import 'app_bar.dart';

class IntermediateAttentionKnowledgeTestScreen extends StatefulWidget {
  final String testType;
  final String testLevel;
  final Function(int) onCompleted;

  const IntermediateAttentionKnowledgeTestScreen({
    super.key,
    required this.testType,
    required this.testLevel,
    required this.onCompleted,
  });

  @override
  _IntermediateAttentionKnowledgeTestScreenState createState() =>
      _IntermediateAttentionKnowledgeTestScreenState();
}

class _IntermediateAttentionKnowledgeTestScreenState
    extends State<IntermediateAttentionKnowledgeTestScreen> {
  int correctAnswers = 0;
  int currentQuestionIndex = 0;

  final List<Question> questions = [
    Question(
      questionText: '¿Cuál es la función principal de un médico de familia?',
      choices: [
        'Proporcionar atención integral y continuada',
        'Realizar cirugías',
        'Atender solo emergencias',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es una consulta multidisciplinaria?',
      choices: [
        'Consulta telefónica con el médico',
        'Consulta por internet',
        'Atención coordinada por varios especialistas',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué es la telemedicina?',
      choices: [
        'Proporcionar servicios médicos a distancia',
        'Atención médica en la clínica',
        'Administrar medicamentos',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuál es la diferencia entre atención primaria y atención secundaria?',
      choices: [
        'La atención primaria trata enfermedades graves, la atención secundaria trata enfermedades leves',
        'La atención primaria es en el hospital, la atención secundaria es en casa',
        'La atención primaria es la primera línea, la atención secundaria implica especialistas',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué es una unidad de atención domiciliaria?',
      choices: [
        'Servicio de emergencia',
        'Departamento hospitalario',
        'Equipo médico que visita pacientes en casa',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué significa EHR?',
      choices: [
        'Electronic Health Record (Historial de Salud Electrónico)',
        'Emergency Health Response (Respuesta Sanitaria de Emergencia)',
        'Everyday Health Routine (Rutina de Salud Diaria)',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es la gestión de casos?',
      choices: [
        'Registrar información médica',
        'Coordinación de servicios para pacientes con necesidades complejas',
        'Realizar pruebas diagnósticas',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Qué es una consulta preventiva?',
      choices: [
        'Visita para tratar enfermedades',
        'Visita para prevenir enfermedades',
        'Visita de emergencia',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Qué es un triage?',
      choices: [
        'Clasificación de los pacientes según la gravedad',
        'Prueba de laboratorio',
        'Consulta con el farmacéutico',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es la educación para la salud?',
      choices: [
        'Programas para enseñar hábitos saludables',
        'Entrenamiento para profesionales médicos',
        'Cursos de medicina',
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