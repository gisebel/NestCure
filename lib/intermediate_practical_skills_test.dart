import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class IntermediatePracticalSkillsTestScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Test de Habilitats Pràctiques - $testLevel'),
      ),
      body: SurveyKit(
        onResult: (SurveyResult result) {
          onCompleted();
          Navigator.of(context).pop();
        },
        task: _getSampleSurveyTask(),
        showProgress: true,
        localizations: const {
          'cancel': 'Cancel·lar',
          'next': 'Següent',
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
          title: 'Benvingut al Test de Habilitats Pràctiques Intermedi',
          text: 'A continuació, realitzaràs una sèrie de preguntes per validar els teus coneixements.',
          buttonText: 'Començar',
        ),
        QuestionStep(
          title: 'Pregunta 1',
          text: '¿Qué debe hacerse si una persona responde pero está experimentando dificultad para respirar?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Dejar que se siente y respire lentamente.', value: 'wrong1'),
              TextChoice(text: 'Realizar la maniobra de Heimlich.', value: 'wrong2'),
              TextChoice(text: 'Animarla a toser para intentar despejar las vías respiratorias.', value: 'correct'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 2',
          text: '¿Cuál es el propósito principal de las ventilaciones en la RCP?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Mantener la circulación sanguínea.', value: 'wrong1'),
              TextChoice(text: 'Saturar los pulmones con oxígeno.', value: 'correct'),
              TextChoice(text: 'Prevenir la hipoventilación.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 3',
          text: '¿Cuál es el paso inicial para ayudar a una persona que está atragantada y no puede hablar ni toser?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Realizar compresiones abdominales.', value: 'wrong1'),
              TextChoice(text: 'Administrar ventilaciones.', value: 'wrong2'),
              TextChoice(text: 'Realizar la maniobra de Heimlich.', value: 'correct'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 4',
          text: '¿Cuál es la técnica adecuada para abrir las vías aéreas de una persona inconsciente?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Inclinar la cabeza hacia atrás y elevar la barbilla.', value: 'correct'),
              TextChoice(text: 'Girar la cabeza hacia un lado y levantar la barbilla.', value: 'wrong1'),
              TextChoice(text: 'Presionar el abdomen en dirección opuesta al esternón.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 5',
          text: '¿Qué deberías hacer si te encuentras solo con una persona inconsciente que no está respirando?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Llamar al número de emergencias y comenzar la RCP.', value: 'correct'),
              TextChoice(text: 'Intentar mover a la persona a un lugar más seguro antes de iniciar la RCP.', value: 'wrong1'),
              TextChoice(text: 'Administrar ventilaciones antes de las compresiones torácicas.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 6',
          text: '¿Cuántas veces debes comprimir el pecho durante una serie de RCP en un adulto?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Al menos 100 veces.', value: 'correct'),
              TextChoice(text: 'Al menos 30 veces.', value: 'wrong1'),
              TextChoice(text: 'Al menos 50 veces.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 7',
          text: '¿Cuál es la causa más común de obstrucción de las vías respiratorias en adultos que requiere la maniobra de Heimlich?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Alimentos sólidos.', value: 'correct'),
              TextChoice(text: 'Líquidos.', value: 'wrong1'),
              TextChoice(text: 'Obstrucciones mecánicas.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 8',
          text: '¿Qué debe hacerse después de administrar las primeras compresiones torácicas en la RCP?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Reevaluar las vías respiratorias.', value: 'correct'),
              TextChoice(text: 'Administrar dos ventilaciones.', value: 'wrong1'),
              TextChoice(text: 'Comprobar el pulso carotídeo.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 9',
          text: '¿Cuál es la profundidad adecuada para las compresiones torácicas en un niño?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Al menos 5 centímetros.', value: 'wrong1'),
              TextChoice(text: 'Al menos 3 centímetros.', value: 'correct'),
              TextChoice(text: 'Al menos 2 centímetros.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 10',
          text: '¿Qué posición debe tener el rescatador al administrar compresiones torácicas en un entorno no médico?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'De rodillas al lado de la persona.', value: 'wrong1'),
              TextChoice(text: 'De pie detrás de la persona.', value: 'correct'),
              TextChoice(text: 'Arrodillado frente a la persona.', value: 'wrong2'),
            ],
          ),
        ),
        CompletionStep(
          stepIdentifier: StepIdentifier(id: 'completion'),
          text: 'Has completat el test. Gràcies per la teva participació!',
          title: 'Fi del Test',
          buttonText: 'Finalitzar',
        ),
      ],
    );
  }
}
