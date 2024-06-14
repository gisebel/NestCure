import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class IntermediateHealthKnowledgeTestScreen extends StatelessWidget {
  final String testType;
  final String testLevel;
  final VoidCallback onCompleted;

  const IntermediateHealthKnowledgeTestScreen({
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
        title: Text('Test de Coneixements Salut - $testLevel'),
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
          title: 'Benvingut al Test de Coneixements de Salut Intermedi',
          text: 'A continuació, realitzaràs una sèrie de preguntes per validar els teus coneixements.',
          buttonText: 'Començar',
        ),
        QuestionStep(
          title: 'Pregunta 1',
          text: 'Què és l\'arítmia?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Batecs irregulars del cor', value: 'correct'),
              TextChoice(text: 'Alta pressió sanguínia', value: 'wrong1'),
              TextChoice(text: 'Dolor toràcic', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 2',
          text: 'Com es pot identificar un ictus?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Debilitat facial i dificultat per parlar', value: 'correct'),
              TextChoice(text: 'Dolor abdominal', value: 'wrong1'),
              TextChoice(text: 'Dolor lumbar', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 3',
          text: 'Què és un anafilaxi?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Reacció al·lèrgica greu', value: 'correct'),
              TextChoice(text: 'Infecció viral', value: 'wrong1'),
              TextChoice(text: 'Trastorn mental', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 4',
          text: 'Com es pot tractar una picada d\'abella?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Retirar el fibló i aplicar fred', value: 'correct'),
              TextChoice(text: 'Aplicar calor', value: 'wrong1'),
              TextChoice(text: 'Utilitzar alcohol', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 5',
          text: 'Quin tipus de ferida necessita punts de sutura?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Ferida profunda i oberta', value: 'correct'),
              TextChoice(text: 'Ferida petita i superficial', value: 'wrong1'),
              TextChoice(text: 'Rascada lleu', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 6',
          text: 'Què és la hipoglucèmia?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Baix nivell de sucre en sang', value: 'correct'),
              TextChoice(text: 'Alt nivell de sucre en sang', value: 'wrong1'),
              TextChoice(text: 'Alt nivell de colesterol', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 7',
          text: 'Què significa BLS en atenció mèdica?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Suport Vital Bàsic', value: 'correct'),
              TextChoice(text: 'Suport Vital Avançat', value: 'wrong1'),
              TextChoice(text: 'Sistema de Vida Bàsica', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 8',
          text: 'Com es tracta una fractura òssia?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Immobilitzar i buscar atenció mèdica', value: 'correct'),
              TextChoice(text: 'Aplicar calor', value: 'wrong1'),
              TextChoice(text: 'Fer massatges a la zona', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 9',
          text: 'Què és l\'asistòlia?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Absència d\'activitat elèctrica al cor', value: 'correct'),
              TextChoice(text: 'Ritme cardíac lent', value: 'wrong1'),
              TextChoice(text: 'Contraccions ventricul·lars prematures', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 10',
          text: 'Quin és el primer pas en la reanimació cardiopulmonar (RCP)?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Verificar si la persona respon', value: 'correct'),
              TextChoice(text: 'Començar compressions toràciques', value: 'wrong1'),
              TextChoice(text: 'Donar respiracions artificials', value: 'wrong2'),
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


