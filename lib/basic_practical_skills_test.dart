import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class BasicPracticalSkillsTestScreen extends StatelessWidget {
  final String testType;
  final String testLevel;
  final VoidCallback onCompleted;

  const BasicPracticalSkillsTestScreen({
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
        title: Text('Test de habilitats prácticas - $testLevel'),
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
          title: 'Bienvenido al Test de Habilidades Prácticas Básico',
          text: 'A continuación, realizarás una serie de preguntas para validar tus conocimientos.',
          buttonText: 'Comenzar',
        ),
        QuestionStep(
          title: 'Pregunta 1',
          text: '¿Qué acción debes tomar primero en caso de presenciar a alguien desmayado en el suelo?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Llamar al número de emergencias.', value: 'correct'),
              TextChoice(text: 'Sacudir a la persona para despertarla.', value: 'wrong1'),
              TextChoice(text: 'Verificar la respiración y la conciencia.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 2',
          text: '¿Cuál es la posición adecuada para colocar a una persona inconsciente que respira normalmente?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'De lado, en posición de recuperación.', value: 'correct'),
              TextChoice(text: 'Sentada con la cabeza inclinada hacia atrás.', value: 'wrong1'),
              TextChoice(text: 'Boca arriba con las piernas levantadas.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 3',
          text: '¿Qué se debe hacer después de confirmar que una persona no responde y no respira normalmente?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Realizar compresiones torácicas.', value: 'correct'),
              TextChoice(text: 'Administrar agua para ayudar en la respiración.', value: 'wrong1'),
              TextChoice(text: 'Darle palmadas en la espalda.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 4',
          text: '¿Cuál es el ritmo recomendado para las compresiones torácicas durante la RCP?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: '100-120 compresiones por minuto', value: 'correct'),
              TextChoice(text: '80-100 compresiones por minuto', value: 'wrong1'),
              TextChoice(text: '120-140 compresiones por minuto', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 5',
          text: '¿Cuál es la ubicación correcta para realizar las compresiones torácicas en un adulto?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'En el centro del pecho, entre los pezones.', value: 'correct'),
              TextChoice(text: 'En la parte inferior del esternón.', value: 'wrong1'),
              TextChoice(text: 'En la parte superior del abdomen.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 6',
          text: '¿Cuál es la profundidad adecuada para las compresiones torácicas en un adulto?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Al menos 5 centímetros.', value: 'correct'),
              TextChoice(text: 'Al menos 2 centímetros.', value: 'wrong1'),
              TextChoice(text: 'Al menos 10 centímetros.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 7',
          text: '¿Cuál es el siguiente paso después de asegurar que las vías respiratorias están despejadas?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Iniciar la respiración artificial.', value: 'correct'),
              TextChoice(text: 'Evaluar el pulso.', value: 'wrong1'),
              TextChoice(text: 'Comenzar las compresiones torácicas.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 8',
          text: '¿Cuál es la secuencia correcta para administrar RCP básica a un adulto?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Compresiones torácicas -> Apertura de las vías aéreas -> Ventilaciones.', value: 'correct'),
              TextChoice(text: 'Ventilaciones -> Compresiones torácicas -> Apertura de las vías aéreas.', value: 'wrong1'),
              TextChoice(text: 'Apertura de las vías aéreas -> Compresiones torácicas -> Ventilaciones.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 9',
          text: '¿Cuántas ventilaciones deben administrarse por cada serie de compresiones torácicas en la RCP básica?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: '2 ventilaciones.', value: 'correct'),
              TextChoice(text: '5 ventilaciones.', value: 'wrong1'),
              TextChoice(text: '1 ventilación.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 10',
          text: '¿Cuál es la posición adecuada para realizar las compresiones torácicas en un bebé?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'En el centro del pecho, entre los pezones.', value: 'correct'),
              TextChoice(text: 'En el estómago, justo debajo del ombligo.', value: 'wrong1'),
              TextChoice(text: 'En la parte inferior del esternón.', value: 'wrong2'),
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
