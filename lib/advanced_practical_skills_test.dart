import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class AdvancedPracticalSkillsTestScreen extends StatelessWidget {
  final String testType;
  final String testLevel;
  final VoidCallback onCompleted;

  const AdvancedPracticalSkillsTestScreen({
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
          title: 'Bienvenido al Test de Habilidades Prácticas Avanzadas',
          text: 'A continuación, realizarás una serie de preguntas para validar tus conocimientos.',
          buttonText: 'Comenzar',
        ),
        QuestionStep(
          title: 'Pregunta 1',
          text: '¿Cuáles son las diferencias principales entre la RCP básica y la avanzada?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'La RCP avanzada incluye el uso de desfibriladores automáticos externos.', value: 'correct'),
              TextChoice(text: 'La RCP avanzada requiere el uso de medicamentos intravenosos.', value: 'wrong1'),
              TextChoice(text: 'La RCP básica se enfoca solo en la RCP externa, mientras que la avanzada incluye la intubación y el uso de drogas.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 2',
          text: '¿Qué es la ventilación con bolsa-mascarilla y cuándo se utiliza en la RCP avanzada?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Es una técnica para proporcionar ventilaciones controladas a través de una máscara y se utiliza cuando se necesita una ventilación más precisa.', value: 'correct'),
              TextChoice(text: 'Es una técnica para administrar oxígeno puro a través de una bolsa y se utiliza solo en hospitales.', value: 'wrong1'),
              TextChoice(text: 'Es una técnica para estabilizar la mandíbula durante la RCP y se utiliza en situaciones de trauma grave.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 3',
          text: '¿Cuál es el objetivo principal de la desfibrilación durante la RCP avanzada?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Restaurar el ritmo cardíaco normal mediante la aplicación de corriente eléctrica.', value: 'correct'),
              TextChoice(text: 'Estimular el sistema nervioso central para mejorar la circulación sanguínea.', value: 'wrong1'),
              TextChoice(text: 'Mejorar la oxigenación pulmonar utilizando dispositivos avanzados.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 4',
          text: '¿Qué se debe hacer si una persona en paro cardíaco muestra signos de respuesta a la desfibrilación inicial?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Continuar con la RCP y administrar otra descarga si es necesario.', value: 'correct'),
              TextChoice(text: 'Detener la RCP y observar si la persona se recupera espontáneamente.', value: 'wrong1'),
              TextChoice(text: 'Administrar un medicamento antiarrítmico por vía intravenosa.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 5',
          text: '¿Cuándo se considera la intubación traqueal en la gestión avanzada de la vía aérea durante la RCP?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Cuando la ventilación con bolsa-mascarilla no es adecuada o posible.', value: 'correct'),
              TextChoice(text: 'Cuando se sospecha de un trauma en la columna cervical.', value: 'wrong1'),
              TextChoice(text: 'Cuando se necesita una evaluación más detallada de las vías respiratorias.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 6',
          text: '¿Qué es el monitoreo del CO2 espirado y cómo ayuda en la RCP avanzada?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Es la medición de dióxido de carbono exhalado que indica la efectividad de las compresiones y ventilaciones.', value: 'correct'),
              TextChoice(text: 'Es una técnica para evaluar la función pulmonar antes y después de la RCP.', value: 'wrong1'),
              TextChoice(text: 'Es una forma de monitorear la saturación de oxígeno durante la RCP.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 7',
          text: '¿Cuál es el papel de los medicamentos durante la RCP avanzada?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Estabilizar el ritmo cardíaco y mejorar la contracción del corazón.', value: 'correct'),
              TextChoice(text: 'Administrar analgésicos para aliviar el dolor durante la RCP.', value: 'wrong1'),
              TextChoice(text: 'Redirigir el flujo sanguíneo hacia los órganos vitales.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 8',
          text: '¿Qué se debe hacer después de administrar una descarga eléctrica exitosa durante la RCP avanzada?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Reanudar inmediatamente las compresiones torácicas.', value: 'correct'),
              TextChoice(text: 'Administrar una dosis adicional de medicamento antiarrítmico.', value: 'wrong1'),
              TextChoice(text: 'Observar la respuesta del paciente durante al menos 5 minutos antes de continuar.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 9',
          text: '¿Cuándo se considera la terapia de perfusión cerebral dirigida durante la RCP avanzada?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Cuando es necesario optimizar la presión y el flujo sanguíneo cerebral para mejorar los resultados neurológicos.', value: 'correct'),
              TextChoice(text: 'Cuando se detecta un infarto agudo de miocardio durante la RCP.', value: 'wrong1'),
              TextChoice(text: 'Cuando se requiere una intervención quirúrgica inmediata para corregir una obstrucción en las arterias coronarias.', value: 'wrong2'),
            ],
          ),
        ),
        QuestionStep(
          title: 'Pregunta 10',
          text: '¿Qué medidas se deben tomar para minimizar la interrupción de las compresiones torácicas durante la RCP avanzada?',
          answerFormat: const SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Optimizar la coordinación del equipo para cambios rápidos y eficientes en las tareas.', value: 'correct'),
              TextChoice(text: 'Reducir la frecuencia de las evaluaciones de ritmo y pulso para enfocarse en la calidad de las compresiones.', value: 'wrong1'),
              TextChoice(text: 'Aumentar la frecuencia de rotación del personal para mantener la energía y la eficiencia durante la RCP.', value: 'wrong2'),
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
