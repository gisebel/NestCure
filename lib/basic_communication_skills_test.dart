import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class BasicCommunicationSkillsTestScreen extends StatelessWidget {
  final String testType;
  final String testLevel;
  final VoidCallback onCompleted;

  const BasicCommunicationSkillsTestScreen({
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
        title: Text('Test de Habilitats de Comunicació - $testLevel'),
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
          title: 'Benvingut al Test de Habilitats de Comunicació Bàsic',
          text: 'A continuació, realitzaràs una sèrie de preguntes per validar les teves habilitats.',
          buttonText: 'Començar',
        ),
        QuestionStep(
          title: 'Pregunta 1',
          text: 'Quina és la tècnica de comunicació més efectiva?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Escolta activa', value: 'correct'),
              TextChoice(text: 'Parlar més alt', value: 'wrong1'),
              TextChoice(text: 'Evitar el contacte visual', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 2',
          text: 'Com es pot millorar la comunicació verbal?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Parlant clarament i pausadament', value: 'correct'),
              TextChoice(text: 'Interrompent constantment', value: 'wrong1'),
              TextChoice(text: 'Parlant molt ràpid', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 3',
          text: 'Què és important en la comunicació no verbal?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Llenguatge corporal i expressió facial', value: 'correct'),
              TextChoice(text: 'Parlar molt', value: 'wrong1'),
              TextChoice(text: 'Escriure correctament', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 4',
          text: 'Què és l\'empatia en la comunicació?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Comprendre i compartir els sentiments dels altres', value: 'correct'),
              TextChoice(text: 'Estar d\'acord amb tot', value: 'wrong1'),
              TextChoice(text: 'Parlar més de nosaltres mateixos', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 5',
          text: 'Com es pot millorar la comprensió en una conversa?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Parafrasejant el que diu l\'altra persona', value: 'correct'),
              TextChoice(text: 'Parlant més ràpid', value: 'wrong1'),
              TextChoice(text: 'Interrompent l\'altra persona', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 6',
          text: 'Què significa mantenir el contacte visual?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Mirar als ulls de l\'interlocutor', value: 'correct'),
              TextChoice(text: 'Mirar cap a un altre costat', value: 'wrong1'),
              TextChoice(text: 'Evitar la mirada', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 7',
          text: 'Quina és una barrera comuna en la comunicació?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Sorolls ambientals', value: 'correct'),
              TextChoice(text: 'Escoltar activament', value: 'wrong1'),
              TextChoice(text: 'Parlar amb claredat', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 8',
          text: 'Com es pot mostrar interès durant una conversa?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Fent preguntes rellevants', value: 'correct'),
              TextChoice(text: 'Mirant el mòbil', value: 'wrong1'),
              TextChoice(text: 'Parlant d\'un altre tema', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 9',
          text: 'Què és una comunicació assertiva?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Expressar les opinions amb respecte i fermesa', value: 'correct'),
              TextChoice(text: 'Evitar el conflicte', value: 'wrong1'),
              TextChoice(text: 'Parlar sense parar', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 10',
          text: 'Com es pot millorar la comunicació escrita?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Utilitzant un llenguatge clar i concís', value: 'correct'),
              TextChoice(text: 'Escrivint llargues parrafades', value: 'wrong1'),
              TextChoice(text: 'Utilitzant moltes abreviatures', value: 'wrong2'),
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
