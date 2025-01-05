import 'package:flutter/material.dart';
import 'app_bar.dart';

class AdvancedPracticalSkillsTestScreen extends StatefulWidget {
  final String testType;
  final String testLevel;
  final Function(int) onCompleted;

  const AdvancedPracticalSkillsTestScreen({
    super.key,
    required this.testType,
    required this.testLevel,
    required this.onCompleted,
  });

  @override
  _AdvancedPracticalSkillsTestScreenState createState() =>
      _AdvancedPracticalSkillsTestScreenState();
}

class _AdvancedPracticalSkillsTestScreenState
    extends State<AdvancedPracticalSkillsTestScreen> {
  int correctAnswers = 0;
  int currentQuestionIndex = 0;

  final List<Question> questions = [
    Question(
      questionText: '¿Cuáles son las diferencias principales entre la RCP básica y la avanzada?',
      choices: [
        'La RCP avanzada requiere el uso de medicamentos intravenosos.',
        'La RCP avanzada incluye el uso de desfibriladores automáticos externos.',
        'La RCP básica se enfoca solo en la RCP externa, mientras que la avanzada incluye la intubación y el uso de drogas.',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Qué es la ventilación con bolsa-mascarilla y cuándo se utiliza en la RCP avanzada?',
      choices: [
        'Es una técnica para proporcionar ventilaciones controladas a través de una máscara.',
        'Es una técnica para administrar oxígeno puro a través de una bolsa y se utiliza solo en hospitales.',
        'Es una técnica para estabilizar la mandíbula durante la RCP en situaciones de trauma grave.',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuál es el objetivo principal de la desfibrilación durante la RCP avanzada?',
      choices: [
        'Estimular el sistema nervioso central para mejorar la circulación sanguínea.',
        'Restaurar el ritmo cardíaco normal mediante la aplicación de corriente eléctrica.',
        'Mejorar la oxigenación pulmonar utilizando dispositivos avanzados.',
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Qué se debe hacer si una persona en paro cardíaco muestra signos de respuesta a la desfibrilación inicial?',
      choices: [
        'Detener la RCP y observar si la persona se recupera espontáneamente.',
        'Administrar un medicamento antiarrítmico por vía intravenosa.',
        'Continuar con la RCP y administrar otra descarga si es necesario.',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Cuándo se considera la intubación traqueal en la gestión avanzada de la vía aérea durante la RCP?',
      choices: [
        'Cuando la ventilación con bolsa-mascarilla no es adecuada o posible.',
        'Cuando se sospecha de un trauma en la columna cervical.',
        'Cuando se necesita una evaluación más detallada de las vías respiratorias.',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Qué es el monitoreo del CO2 espirado y cómo ayuda en la RCP avanzada?',
      choices: [
        'Es la medición de dióxido de carbono exhalado que indica la efectividad de las compresiones y ventilaciones.',
        'Es una técnica para evaluar la función pulmonar antes y después de la RCP.',
        'Es una forma de monitorear la saturación de oxígeno durante la RCP.',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuál es el papel de los medicamentos durante la RCP avanzada?',
      choices: [
        'Administrar analgésicos para aliviar el dolor durante la RCP.',
        'Redirigir el flujo sanguíneo hacia los órganos vitales.',
        'Estabilizar el ritmo cardíaco y mejorar la contracción del corazón.',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué se debe hacer después de administrar una descarga eléctrica exitosa durante la RCP avanzada?',
      choices: [
        'Reanudar inmediatamente las compresiones torácicas.',
        'Administrar una dosis adicional de medicamento antiarrítmico.',
        'Observar la respuesta del paciente durante al menos 5 minutos antes de continuar.',
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: '¿Cuándo se considera la terapia de perfusión cerebral dirigida durante la RCP avanzada?',
      choices: [
        'Cuando se detecta un infarto agudo de miocardio durante la RCP.',
        'Cuando se requiere una intervención quirúrgica inmediata.',
        'Cuando es necesario optimizar la presión y el flujo sanguíneo cerebral para mejorar los resultados neurológicos.',
      ],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: '¿Qué medidas se deben tomar para minimizar la interrupción de las compresiones torácicas durante la RCP avanzada?',
      choices: [
        'Reducir la frecuencia de las evaluaciones de ritmo y pulso.',
        'Optimizar la coordinación del equipo para cambios rápidos y eficientes en las tareas.',
        'Aumentar la frecuencia de rotación del personal para mantener la energía.',
      ],
      correctAnswerIndex: 1,
    ),
  ];

  void nextQuestion(int selectedIndex) {
    if (selectedIndex == questions[currentQuestionIndex].correctAnswerIndex) {
      correctAnswers++;
    }

    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        widget.onCompleted(correctAnswers);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CompletionScreen(correctAnswers: correctAnswers),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, true),
      backgroundColor: const Color.fromARGB(255, 255, 251, 245),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'PREGUNTA ${currentQuestionIndex + 1}:',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                questions[currentQuestionIndex].questionText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Column(
                children: questions[currentQuestionIndex]
                    .choices
                    .asMap()
                    .entries
                    .map((entry) {
                  int index = entry.key;
                  String choice = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => nextQuestion(index),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        choice,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompletionScreen extends StatelessWidget {
  final int correctAnswers;

  const CompletionScreen({super.key, required this.correctAnswers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Text(
                'Has completado el test. ¡Gracias por tu participación!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Respuestas correctas: $correctAnswers/10',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16.0,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Finalizar'),
              ),
            ],
        ),
      ),
    );
  }
}

class Question {
  final String questionText;
  final List<String> choices;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.choices,
    required this.correctAnswerIndex,
  });
}
