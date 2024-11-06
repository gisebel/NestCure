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
        title: Text('Test de habilidades de comunicación - $testLevel'),
      ),
      body: SurveyKit(
        onResult: (SurveyResult result) {
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
          title: 'Bienvenido al Test de Habilidades de Comunicación Intermedia',
          text: 'A continuación, realizarás una serie de preguntas para validar tus habilidades.',
          buttonText: 'Comenzar',
        ),
        QuestionStep(
          title: 'Pregunta 1',
          text: '¿Cómo podemos asegurarnos de que hemos entendido correctamente el mensaje de alguien?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Reflejando y parafraseando lo que han dicho', value: 'correct'),
              TextChoice(text: 'Interrumpiendo para aclarar', value: 'wrong1'),
              TextChoice(text: 'Respondiendo inmediatamente', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 2',
          text: '¿Qué es importante tener en cuenta en la comunicación intercultural?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Respetar las diferencias culturales', value: 'correct'),
              TextChoice(text: 'Hablar solo en nuestro idioma', value: 'wrong1'),
              TextChoice(text: 'Suponer que todos entienden nuestra cultura', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 3',
          text: '¿Cómo podemos mejorar nuestra capacidad de escucha activa?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Prestando toda nuestra atención al interlocutor', value: 'correct'),
              TextChoice(text: 'Preparando nuestra respuesta mientras escuchamos', value: 'wrong1'),
              TextChoice(text: 'Multitarea durante la conversación', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 4',
          text: '¿Cómo podemos demostrar empatía en una conversación?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Reconociendo los sentimientos del otro', value: 'correct'),
              TextChoice(text: 'Hablando más de nosotros mismos', value: 'wrong1'),
              TextChoice(text: 'Interrumpiendo para dar consejos', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 5',
          text: '¿Cuál es una técnica para mejorar la comunicación en un grupo?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Establecer normas claras de comunicación', value: 'correct'),
              TextChoice(text: 'Hablar todos a la vez', value: 'wrong1'),
              TextChoice(text: 'Ignorar las aportaciones de los demás', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 6',
          text: '¿Qué significa tener una comunicación clara y concisa?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Expresarse de manera breve y fácil de entender', value: 'correct'),
              TextChoice(text: 'Hablar muy rápido', value: 'wrong1'),
              TextChoice(text: 'Usar palabras complicadas', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 7',
          text: '¿Cómo podemos gestionar una conversación difícil?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Manteniendo la calma y la objetividad', value: 'correct'),
              TextChoice(text: 'Elevando la voz para hacernos entender', value: 'wrong1'),
              TextChoice(text: 'Evitando el tema completamente', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 8',
          text: '¿Cómo podemos evitar malentendidos en la comunicación escrita?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Revisando y aclarando el mensaje', value: 'correct'),
              TextChoice(text: 'Usando muchas abreviaturas', value: 'wrong1'),
              TextChoice(text: 'Escribiendo muy rápido', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 9',
          text: '¿Qué es el feedback constructivo?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Comentarios positivos y sugerencias para mejorar', value: 'correct'),
              TextChoice(text: 'Críticas negativas sin soluciones', value: 'wrong1'),
              TextChoice(text: 'Ignorar los errores de los demás', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 10',
          text: '¿Qué es importante para mantener una buena relación comunicativa?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Respetar y valorar la opinión del otro', value: 'correct'),
              TextChoice(text: 'Hablar más que el otro', value: 'wrong1'),
              TextChoice(text: 'Estar de acuerdo en todo', value: 'wrong2'),
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
