import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class IntermediateAttentionKnowledgeTestScreen extends StatelessWidget {
  final String testType;
  final String testLevel;
  final VoidCallback onCompleted;

  const IntermediateAttentionKnowledgeTestScreen({
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
          title: 'Bienvenido al Test de Conocimientos de Atención Intermedia',
          text: 'A continuación, realizarás una serie de preguntas para validar tus conocimientos.',
          buttonText: 'Comenzar',
        ),
        QuestionStep(
          title: 'Pregunta 1',
          text: '¿Cuál es la función principal de un médico de familia?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Proporcionar atención integral y continuada', value: 'correct'),
              TextChoice(text: 'Realizar cirugías', value: 'wrong1'),
              TextChoice(text: 'Atender solo emergencias', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 2',
          text: '¿Qué es una consulta multidisciplinaria?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Atención coordinada por varios especialistas', value: 'correct'),
              TextChoice(text: 'Consulta telefónica con el médico', value: 'wrong1'),
              TextChoice(text: 'Consulta por internet', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 3',
          text: '¿Qué es la telemedicina?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Proporcionar servicios médicos a distancia', value: 'correct'),
              TextChoice(text: 'Atención médica en la clínica', value: 'wrong1'),
              TextChoice(text: 'Administrar medicamentos', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 4',
          text: '¿Cuál es la diferencia entre atención primaria y atención secundaria?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'La atención primaria es la primera línea, la atención secundaria implica especialistas', value: 'correct'),
              TextChoice(text: 'La atención primaria trata enfermedades graves, la atención secundaria trata enfermedades leves', value: 'wrong1'),
              TextChoice(text: 'La atención primaria es en el hospital, la atención secundaria es en casa', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 5',
          text: '¿Qué es una unidad de atención domiciliaria?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Equipo médico que visita pacientes en casa', value: 'correct'),
              TextChoice(text: 'Servicio de emergencia', value: 'wrong1'),
              TextChoice(text: 'Departamento hospitalario', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 6',
          text: '¿Qué significa EHR?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Electronic Health Record (Historial de Salud Electrónico)', value: 'correct'),
              TextChoice(text: 'Emergency Health Response (Respuesta Sanitaria de Emergencia)', value: 'wrong1'),
              TextChoice(text: 'Everyday Health Routine (Rutina de Salud Diaria)', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 7',
          text: '¿Qué es la gestión de casos?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Coordinación de servicios para pacientes con necesidades complejas', value: 'correct'),
              TextChoice(text: 'Registrar información médica', value: 'wrong1'),
              TextChoice(text: 'Realizar pruebas diagnósticas', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 8',
          text: '¿Qué es una consulta preventiva?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Visita para prevenir enfermedades', value: 'correct'),
              TextChoice(text: 'Visita para tratar enfermedades', value: 'wrong1'),
              TextChoice(text: 'Visita de emergencia', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 9',
          text: '¿Qué es un triage?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Clasificación de los pacientes según la gravedad', value: 'correct'),
              TextChoice(text: 'Prueba de laboratorio', value: 'wrong1'),
              TextChoice(text: 'Consulta con el farmacéutico', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 10',
          text: '¿Qué es la educación para la salud?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Programas para enseñar hábitos saludables', value: 'correct'),
              TextChoice(text: 'Entrenamiento para profesionales médicos', value: 'wrong1'),
              TextChoice(text: 'Cursos de medicina', value: 'wrong2'),
            ],
          ),
        ),
        CompletionStep(
          stepIdentifier: StepIdentifier(id: 'completion'),
          text: 'Has completado el test. ¡Gracias por tu participación!',
          title: 'Fin del Test',
          buttonText: 'Finalizar',
        ),
      ],
    );
  }
}