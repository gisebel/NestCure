import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class HealthKnowledgeTestScreen extends StatelessWidget {
  final String testType;
  final String testLevel;
  final VoidCallback onCompleted;

  const HealthKnowledgeTestScreen({
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
          title: 'Benvingut al Test de Coneixements de Salut Bàsic',
          text: 'A continuació, realitzaràs una sèrie de preguntes per validar els teus coneixements.',
          buttonText: 'Començar',
        ),
        QuestionStep(
          title: 'Pregunta 1',
          text: 'Què és la RCP?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Reanimació CardioPulmonar', value: 'correct'),
              TextChoice(text: 'Respiració Controlada Progressiva', value: 'wrong1'),
              TextChoice(text: 'Reacción Cutánea Postural', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 2',
          text: 'Quin és el símbol de l\'emergència mèdica?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Creu Vermella', value: 'correct'),
              TextChoice(text: 'Estrella de David', value: 'wrong1'),
              TextChoice(text: 'Caduceu', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 3',
          text: 'Quin és el número d\'emergències?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: '112', value: 'correct'),
              TextChoice(text: '911', value: 'wrong1'),
              TextChoice(text: '123', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 4',
          text: 'Què s\'ha de fer primer en cas d\'una ferida sagnant?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Aplicar pressió', value: 'correct'),
              TextChoice(text: 'Posar aigua', value: 'wrong1'),
              TextChoice(text: 'Col·locar un apòsit', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 5',
          text: 'Com es pot prevenir un refredat comú?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Rentant-se les mans', value: 'correct'),
              TextChoice(text: 'Bevent molta aigua', value: 'wrong1'),
              TextChoice(text: 'Prenent vitamines', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 6',
          text: 'Què significa AED?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Desfibril·lador Extern Automàtic', value: 'correct'),
              TextChoice(text: 'Dispositiu Electrònic d\'Ajuda', value: 'wrong1'),
              TextChoice(text: 'Equip de Emergències Avançades', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 7',
          text: 'Què s\'ha de fer en cas d\'una cremada menor?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Aplicar aigua freda', value: 'correct'),
              TextChoice(text: 'Posar oli', value: 'wrong1'),
              TextChoice(text: 'Cobrir amb una manta', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 8',
          text: 'Quina és la causa més comuna d\'un atac cardíac?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Bloqueig de les artèries coronàries', value: 'correct'),
              TextChoice(text: 'Febre alta', value: 'wrong1'),
              TextChoice(text: 'Infecció bacteriana', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 9',
          text: 'Quin és el millor lloc per comprovar el pols en un adult conscient?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Canell', value: 'correct'),
              TextChoice(text: 'Coll', value: 'wrong1'),
              TextChoice(text: 'Peu', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 10',
          text: 'Quina és la temperatura corporal normal en un ésser humà?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: '36.5-37.5 °C', value: 'correct'),
              TextChoice(text: '35-36 °C', value: 'wrong1'),
              TextChoice(text: '38-39 °C', value: 'wrong2'),
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

















