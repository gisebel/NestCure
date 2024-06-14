import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class IntermediateCommunicationSkillsTestScreen extends StatelessWidget {
  final String testType;
  final String testLevel;
  final VoidCallback onCompleted;

  const IntermediateCommunicationSkillsTestScreen({
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
          title: 'Benvingut al Test de Habilitats de Comunicació Intermedi',
          text: 'A continuació, realitzaràs una sèrie de preguntes per validar les teves habilitats.',
          buttonText: 'Començar',
        ),
        QuestionStep(
          title: 'Pregunta 1',
          text: 'Com podem assegurar-nos que hem entès correctament el missatge d\'algú?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Reflectint i parafrasejant el que han dit', value: 'correct'),
              TextChoice(text: 'Interrompent per aclarir', value: 'wrong1'),
              TextChoice(text: 'Respondent immediatament', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 2',
          text: 'Què és important tenir en compte en la comunicació intercultural?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Respectar les diferències culturals', value: 'correct'),
              TextChoice(text: 'Parlar només en la nostra llengua', value: 'wrong1'),
              TextChoice(text: 'Assumir que tothom entén la nostra cultura', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 3',
          text: 'Com podem millorar la nostra capacitat d\'escolta activa?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Donant tota la nostra atenció a l\'interlocutor', value: 'correct'),
              TextChoice(text: 'Preparant la nostra resposta mentre escoltem', value: 'wrong1'),
              TextChoice(text: 'Multitasca durant la conversa', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 4',
          text: 'Com podem demostrar empatia en una conversa?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Reconeguent els sentiments de l\'altre', value: 'correct'),
              TextChoice(text: 'Parlant més de nosaltres mateixos', value: 'wrong1'),
              TextChoice(text: 'Interrompent per donar consells', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 5',
          text: 'Quina és una tècnica per millorar la comunicació en un grup?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Establir normes clares de comunicació', value: 'correct'),
              TextChoice(text: 'Parlar tots alhora', value: 'wrong1'),
              TextChoice(text: 'Ignorar les aportacions dels altres', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 6',
          text: 'Què significa tenir una comunicació clara i concisa?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Expressar-se de manera breu i fàcil d\'entendre', value: 'correct'),
              TextChoice(text: 'Parlar molt ràpid', value: 'wrong1'),
              TextChoice(text: 'Utilitzar paraules complicades', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 7',
          text: 'Com podem gestionar una conversa difícil?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Mantenint la calma i l\'objectivitat', value: 'correct'),
              TextChoice(text: 'Elevant la veu per fer-nos entendre', value: 'wrong1'),
              TextChoice(text: 'Evitant el tema completament', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 8',
          text: 'Com podem evitar malentesos en la comunicació escrita?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Revisant i clarificant el missatge', value: 'correct'),
              TextChoice(text: 'Utilitzant moltes abreviatures', value: 'wrong1'),
              TextChoice(text: 'Escrivint molt ràpid', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 9',
          text: 'Què és el feedback constructiu?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Comentaris positius i suggeriments per millorar', value: 'correct'),
              TextChoice(text: 'Crítiques negatives sense solucions', value: 'wrong1'),
              TextChoice(text: 'Ignorar els errors dels altres', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 10',
          text: 'Què és important per mantenir una bona relació comunicativa?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Respectar i valorar l\'opinió de l\'altre', value: 'correct'),
              TextChoice(text: 'Parlar més que l\'altre', value: 'wrong1'),
              TextChoice(text: 'Estar d\'acord en tot', value: 'wrong2'),
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
