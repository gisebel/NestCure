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
          title: 'Benvingut al Test de Coneixements de Salut Avançat',
          text: 'A continuació, realitzaràs una sèrie de preguntes per validar els teus coneixements.',
          buttonText: 'Començar',
        ),
        QuestionStep(
          title: 'Pregunta 1',
          text: 'Què és l\'edema pulmonar?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Acumulació de líquid als pulmons', value: 'correct'),
              TextChoice(text: 'Infecció bacteriana dels pulmons', value: 'wrong1'),
              TextChoice(text: 'Càncer de pulmó', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 2',
          text: 'Quin és el tractament inicial per a un infart agut de miocardi?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Administrar aspirina', value: 'correct'),
              TextChoice(text: 'Donar begudes calentes', value: 'wrong1'),
              TextChoice(text: 'Aplicar gel', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 3',
          text: 'Què és un pneumotòrax?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Presència d\'aire a la cavitat pleural', value: 'correct'),
              TextChoice(text: 'Inflamació de la pleura', value: 'wrong1'),
              TextChoice(text: 'Infecció pulmonar greu', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 4',
          text: 'Quin medicament es fa servir habitualment per a tractar la diabetis tipus 2?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Metformina', value: 'correct'),
              TextChoice(text: 'Insulina', value: 'wrong1'),
              TextChoice(text: 'Amoxicil·lina', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 5',
          text: 'Quin és un símptoma comú de la insuficiència cardíaca congestiva?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Dificultat per respirar', value: 'correct'),
              TextChoice(text: 'Dolor de cap', value: 'wrong1'),
              TextChoice(text: 'Mal de coll', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 6',
          text: 'Què és la bradicàrdia?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Ritme cardíac anormalment lent', value: 'correct'),
              TextChoice(text: 'Ritme cardíac ràpid', value: 'wrong1'),
              TextChoice(text: 'Absència de ritme cardíac', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 7',
          text: 'Quin és l\'objectiu principal de la teràpia amb anticoagulants?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Prevenir la formació de coàguls', value: 'correct'),
              TextChoice(text: 'Reduir el dolor', value: 'wrong1'),
              TextChoice(text: 'Augmentar la pressió sanguínia', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 8',
          text: 'Què és la fibril·lació auricular?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Ritme cardíac ràpid i irregular', value: 'correct'),
              TextChoice(text: 'Ritme cardíac lent i regular', value: 'wrong1'),
              TextChoice(text: 'Absència de ritme cardíac', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 9',
          text: 'Què és la septicèmia?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Infecció generalitzada a la sang', value: 'correct'),
              TextChoice(text: 'Infecció localitzada a la pell', value: 'wrong1'),
              TextChoice(text: 'Inflamació dels ganglis limfàtics', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 10',
          text: 'Quin és l\'efecte secundari més comú dels inhibidors de l\'ECA?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Tos seca', value: 'correct'),
              TextChoice(text: 'Nàusees', value: 'wrong1'),
              TextChoice(text: 'Marejos', value: 'wrong2'),
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


