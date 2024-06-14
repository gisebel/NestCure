import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class AdvancedCommunicationSkillsTestScreen extends StatelessWidget {
  final String testType;
  final String testLevel;
  final VoidCallback onCompleted;

  const AdvancedCommunicationSkillsTestScreen({
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
          title: 'Benvingut al Test de Habilitats de Comunicació Avançat',
          text: 'A continuació, realitzaràs una sèrie de preguntes per validar les teves habilitats.',
          buttonText: 'Començar',
        ),
        QuestionStep(
  title: 'Pregunta 1',
  text: 'Què és la comunicació assertiva?',
  answerFormat: const SingleChoiceAnswerFormat(
    textChoices: [
      TextChoice(text: 'Expressar-se amb confiança i respecte', value: 'correct'),
      TextChoice(text: 'Evitar conflictes a tota costa', value: 'wrong1'),
      TextChoice(text: 'Ser agressiu per fer-se entendre', value: 'wrong2'),
    ],
  ),
),
QuestionStep(
  title: 'Pregunta 2',
  text: 'Com es pot fomentar la comunicació efectiva en un equip?',
  answerFormat: const SingleChoiceAnswerFormat(
    textChoices: [
      TextChoice(text: 'Promovent la col·laboració i la retroalimentació oberta', value: 'correct'),
      TextChoice(text: 'Competint entre els membres', value: 'wrong1'),
      TextChoice(text: 'Ignorant les opinions dels altres', value: 'wrong2'),
    ],
  ),
),
QuestionStep(
  title: 'Pregunta 3',
  text: 'Què és la comunicació intercultural efectiva?',
  answerFormat: const SingleChoiceAnswerFormat(
    textChoices: [
      TextChoice(text: 'Adaptar-se i respectar les diferents cultures', value: 'correct'),
      TextChoice(text: 'Assumir que tothom entén la nostra cultura', value: 'wrong1'),
      TextChoice(text: 'Parlar només en la nostra llengua', value: 'wrong2'),
    ],
  ),
),
QuestionStep(
  title: 'Pregunta 4',
  text: 'Com es pot gestionar un conflicte de manera efectiva?',
  answerFormat: const SingleChoiceAnswerFormat(
    textChoices: [
      TextChoice(text: 'Escoltant activament i buscant solucions', value: 'correct'),
      TextChoice(text: 'Ignorant el problema', value: 'wrong1'),
      TextChoice(text: 'Imposant la nostra opinió', value: 'wrong2'),
    ],
  ),
),
QuestionStep(
  title: 'Pregunta 5',
  text: 'Quina és la importància de la retroalimentació en la comunicació?',
  answerFormat: const SingleChoiceAnswerFormat(
    textChoices: [
      TextChoice(text: 'Millora contínua i clarificació del missatge', value: 'correct'),
      TextChoice(text: 'Criticar els altres', value: 'wrong1'),
      TextChoice(text: 'Evitar la retroalimentació', value: 'wrong2'),
    ],
  ),
),
QuestionStep(
  title: 'Pregunta 6',
  text: 'Què és la intel·ligència emocional en la comunicació?',
  answerFormat: const SingleChoiceAnswerFormat(
    textChoices: [
      TextChoice(text: 'Reconèixer i gestionar les pròpies emocions i les dels altres', value: 'correct'),
      TextChoice(text: 'Evitar parlar de sentiments', value: 'wrong1'),
      TextChoice(text: 'Expressar-se agressivament', value: 'wrong2'),
    ],
  ),
),
QuestionStep(
  title: 'Pregunta 7',
  text: 'Com podem assegurar-nos que el nostre missatge ha estat entès correctament?',
  answerFormat: const SingleChoiceAnswerFormat(
    textChoices: [
      TextChoice(text: 'Demanejant una retroalimentació i aclariment', value: 'correct'),
      TextChoice(text: 'Parlant més alt', value: 'wrong1'),
      TextChoice(text: 'Assumint que han entès', value: 'wrong2'),
    ],
  ),
),
QuestionStep(
  title: 'Pregunta 8',
  text: 'Com es pot millorar la comunicació en situacions d\'estrès?',
  answerFormat: const SingleChoiceAnswerFormat(
    textChoices: [
      TextChoice(text: 'Mantenint la calma i escoltant activament', value: 'correct'),
      TextChoice(text: 'Parlant ràpidament', value: 'wrong1'),
      TextChoice(text: 'Evitant la comunicació', value: 'wrong2'),
    ],
  ),
),
QuestionStep(
  title: 'Pregunta 9',
  text: 'Què significa la comunicació bidireccional?',
  answerFormat: const SingleChoiceAnswerFormat(
    textChoices: [
      TextChoice(text: 'Intercanvi actiu d\'informació entre dues parts', value: 'correct'),
      TextChoice(text: 'Una sola persona parla', value: 'wrong1'),
      TextChoice(text: 'Escoltar sense respondre', value: 'wrong2'),
    ],
  ),
),
QuestionStep(
  title: 'Pregunta 10',
  text: 'Com podem evitar malentesos en la comunicació escrita professional?',
  answerFormat: const SingleChoiceAnswerFormat(
    textChoices: [
      TextChoice(text: 'Revisant i clarificant el missatge abans d\'enviar-lo', value: 'correct'),
      TextChoice(text: 'Utilitzant un llenguatge informal', value: 'wrong1'),
      TextChoice(text: 'Escrivint de pressa', value: 'wrong2'),
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

