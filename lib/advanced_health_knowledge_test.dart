import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class AdvancedHealthKnowledgeTestScreen extends StatelessWidget {
  final String testType;
  final String testLevel;
  final VoidCallback onCompleted;

  const AdvancedHealthKnowledgeTestScreen({
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
        title: Text('Test de conocimientos de salud - $testLevel'),
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
          title: 'Bienvenido al Test de Conocimientos de Salud Avanzada',
          text: 'A continuación, realizarás una serie de preguntas para validar tus conocimientos.',
          buttonText: 'Comenzar',
        ),
        QuestionStep(
          title: 'Pregunta 1',
          text: '¿Qué es el edema pulmonar?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Acumulación de líquido en los pulmones', value: 'correct'),
              TextChoice(text: 'Infección bacteriana de los pulmones', value: 'wrong1'),
              TextChoice(text: 'Cáncer de pulmón', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 2',
          text: '¿Cuál es el tratamiento inicial para un infarto agudo de miocardio?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Administrar aspirina', value: 'correct'),
              TextChoice(text: 'Dar bebidas calientes', value: 'wrong1'),
              TextChoice(text: 'Aplicar hielo', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 3',
          text: '¿Qué es un neumotórax?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Presencia de aire en la cavidad pleural', value: 'correct'),
              TextChoice(text: 'Inflamación de la pleura', value: 'wrong1'),
              TextChoice(text: 'Infección pulmonar grave', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 4',
          text: '¿Qué medicamento se usa comúnmente para tratar la diabetes tipo 2?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Metformina', value: 'correct'),
              TextChoice(text: 'Insulina', value: 'wrong1'),
              TextChoice(text: 'Amoxicilina', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 5',
          text: '¿Cuál es un síntoma común de la insuficiencia cardíaca congestiva?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Dificultad para respirar', value: 'correct'),
              TextChoice(text: 'Dolor de cabeza', value: 'wrong1'),
              TextChoice(text: 'Dolor de garganta', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 6',
          text: '¿Qué es la bradicardia?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Ritmo cardíaco anormalmente lento', value: 'correct'),
              TextChoice(text: 'Ritmo cardíaco rápido', value: 'wrong1'),
              TextChoice(text: 'Ausencia de ritmo cardíaco', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 7',
          text: '¿Cuál es el objetivo principal de la terapia con anticoagulantes?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Prevenir la formación de coágulos', value: 'correct'),
              TextChoice(text: 'Reducir el dolor', value: 'wrong1'),
              TextChoice(text: 'Aumentar la presión sanguínea', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 8',
          text: '¿Qué es la fibrilación auricular?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Ritmo cardíaco rápido e irregular', value: 'correct'),
              TextChoice(text: 'Ritmo cardíaco lento y regular', value: 'wrong1'),
              TextChoice(text: 'Ausencia de ritmo cardíaco', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 9',
          text: '¿Qué es la septicemia?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Infección generalizada en la sangre', value: 'correct'),
              TextChoice(text: 'Infección localizada en la piel', value: 'wrong1'),
              TextChoice(text: 'Inflamación de los ganglios linfáticos', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 10',
          text: '¿Cuál es el efecto secundario más común de los inhibidores de la ECA?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Tos seca', value: 'correct'),
              TextChoice(text: 'Náuseas', value: 'wrong1'),
              TextChoice(text: 'Mareos', value: 'wrong2'),
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


