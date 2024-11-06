import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class AdvancedAttentionKnowledgeTestScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Test de conocimientos de atención - $testLevel'),
      ),
      body: SurveyKit(
        onResult: (SurveyResult result) {
          // Procesa el resultado del test
          onCompleted();
          Navigator.of(context).pop();
        },
        task: _getSampleSurveyTask(),
        showProgress: true,
        localizations: const {
          'cancel': 'Cancelar',
          'next': 'Siguiente',
        },
        themeData: Theme.of(context).copyWith(
          primaryColor: Colors.cyan,
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.cyan,
            ),
            titleTextStyle: TextStyle(
              color: Colors.cyan,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.cyan,
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.cyan,
            selectionColor: Colors.cyan,
            selectionHandleColor: Colors.cyan,
          ),
          cupertinoOverrideTheme: const CupertinoThemeData(
            primaryColor: Colors.cyan,
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                const Size(150.0, 60.0),
              ),
              side: MaterialStateProperty.resolveWith(
                (Set<MaterialState> state) {
                  if (state.contains(MaterialState.disabled)) {
                    return const BorderSide(
                      color: Colors.grey,
                    );
                  }
                  return const BorderSide(
                    color: Colors.cyan,
                  );
                },
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              textStyle: MaterialStateProperty.resolveWith(
                (Set<MaterialState> state) {
                  if (state.contains(MaterialState.disabled)) {
                    return Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.grey,
                        );
                  }
                  return Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.cyan,
                      );
                },
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              textStyle: MaterialStateProperty.all(
                Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.cyan,
                    ),
              ),
            ),
          ),
          textTheme: const TextTheme(
            displayMedium: TextStyle(
              fontSize: 28.0,
              color: Colors.black,
            ),
            headlineSmall: TextStyle(
              fontSize: 24.0,
              color: Colors.black,
            ),
            bodyMedium: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
            titleMedium: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(
              color: Colors.black,
            ),
          ),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.cyan,
          ).copyWith(
            onPrimary: Colors.white,
            background: Colors.white,
          ),
        ),
        surveyProgressbarConfiguration: SurveyProgressConfiguration(
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Task _getSampleSurveyTask() {
    return NavigableTask(
      id: TaskIdentifier(),
      steps: [
        InstructionStep(
          title: 'Bienvenido al Test de Conocimientos de Atención Avanzada',
          text: 'A continuación, realizarás una serie de preguntas para validar tus conocimientos.',
          buttonText: 'Comenzar',
        ),
        QuestionStep(
          title: 'Pregunta 1',
          text: '¿Cuál es la diferencia principal entre atención urgente y emergente?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'La atención urgente no es vital, la emergente es crítica', value: 'correct'),
              TextChoice(text: 'La atención urgente es inmediata, la emergente puede esperar', value: 'wrong1'),
              TextChoice(text: 'La atención urgente se da en casa, la emergente en el hospital', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 2',
          text: '¿Cuál es el objetivo de la atención paliativa?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Mejorar la calidad de vida en enfermedades graves', value: 'correct'),
              TextChoice(text: 'Curar enfermedades crónicas', value: 'wrong1'),
              TextChoice(text: 'Proporcionar cuidados intensivos', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 3',
          text: '¿Qué es la continuidad asistencial?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Proporcionar atención consistente y coordinada a lo largo del tiempo', value: 'correct'),
              TextChoice(text: 'Atender solo consultas urgentes', value: 'wrong1'),
              TextChoice(text: 'Hacer un único tratamiento completo', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 4',
          text: '¿Qué es un plan de cuidados individualizado?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Plan de tratamiento específico para un paciente', value: 'correct'),
              TextChoice(text: 'Manual general de cuidados', value: 'wrong1'),
              TextChoice(text: 'Protocolo de emergencias', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 5',
          text: '¿Cuál es la función de un gestor de casos?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Coordinar atención para pacientes con necesidades complejas', value: 'correct'),
              TextChoice(text: 'Administrar medicamentos', value: 'wrong1'),
              TextChoice(text: 'Realizar intervenciones quirúrgicas', value: 'wrong2'), 
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 6',
          text: '¿Qué es una unidad de cuidados intensivos?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Área hospitalaria para pacientes críticos', value: 'correct'),
              TextChoice(text: 'Centro de atención primaria', value: 'wrong1'),
              TextChoice(text: 'Departamento de fisioterapia', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 7',
          text: '¿Qué es una visita de seguimiento?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Consulta posterior para revisar el estado del paciente', value: 'correct'),
              TextChoice(text: 'Primera consulta médica', value: 'wrong1'),
              TextChoice(text: 'Consulta de urgencia', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 8',
          text: '¿Qué es una consulta a distancia?', // 'Què és una consulta a distància?'
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Atención médica proporcionada por teléfono o internet', value: 'correct'), // 'Atenció mèdica proporcionada per telèfon o internet'
              TextChoice(text: 'Visita médica presencial', value: 'wrong1'), // 'Visita mèdica presencial'
              TextChoice(text: 'Consulta de emergencia', value: 'wrong2'), // 'Consulta d\'emergència'
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 9',
          text: '¿Qué es un programa de rehabilitación?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Programas para recuperar la funcionalidad después de una enfermedad o lesión', value: 'correct'),
              TextChoice(text: 'Pruebas diagnósticas', value: 'wrong1'),
              TextChoice(text: 'Procedimientos quirúrgicos', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 10',
          text: '¿Qué es una unidad de salud mental?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Departamento que trata trastornos mentales', value: 'correct'),
              TextChoice(text: 'Servicio de urgencias', value: 'wrong1'),
              TextChoice(text: 'Laboratorio médico', value: 'wrong2'),
            ],
          ),
        ),
        CompletionStep(
          stepIdentifier: StepIdentifier(id: 'completion'),
          text: 'Has completado el test. ¡Gracias por tu participación!',
          title: 'Fin del test',
          buttonText: 'Finalizar',
        ),
      ],
    );
  }
}