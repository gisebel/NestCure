import 'package:flutter/material.dart';
import 'package:nestcure/app_bar.dart';
import 'health_knowledge_test.dart';
import 'intermediate_health_knowledge_test.dart';
import 'advanced_health_knowledge_test.dart';
import 'basic_attention_knowledge_test.dart';
import 'intermediate_attention_knowledge_test.dart';
import 'advanced_attention_knowledge_test.dart';
import 'basic_communication_skills_test.dart';
import 'intermediate_communication_skills_test.dart';
import 'advanced_communication_skills_test.dart';
import 'basic_practical_skills_test.dart'; 
import 'intermediate_practical_skills_test.dart'; 
import 'advanced_practical_skills_test.dart'; 

class KnowledgeTestsScreen extends StatefulWidget {
  const KnowledgeTestsScreen({super.key});

  @override
  _KnowledgeTestsScreenState createState() => _KnowledgeTestsScreenState();
}

class _KnowledgeTestsScreenState extends State<KnowledgeTestsScreen> {
  Map<String, Map<String, String>> testResults = {
    'Coneixements Salut': {},
    'Coneixements d\'atenció': {},
    'Habilitats de comunicació': {},
    'Habilitats pràctiques': {}, 
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Image.asset(
          'images/logo.jpg',
          height: 50,
          fit: BoxFit.cover,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(194, 198, 203, 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.person, color: Color.fromRGBO(20, 39, 53, 1)),
              onPressed: () {
                // Acción para ir al perfil
              },
            ),
          ),
        ],
        centerTitle: true,
      ),
      drawer: const NavigationDrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tests de coneixement',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildTestButton(
              context,
              testType: 'Coneixements Salut',
              levels: ['Bàsic', 'Intermedi', 'Avançat'],
            ),
            const SizedBox(height: 16),
            _buildTestButton(
              context,
              testType: 'Coneixements d\'atenció',
              levels: ['Bàsic', 'Intermedi', 'Avançat'],
            ),
            const SizedBox(height: 16),
            _buildTestButton(
              context,
              testType: 'Habilitats de comunicació',
              levels: ['Bàsic', 'Intermedi', 'Avançat'],
            ),
            const SizedBox(height: 16),
            _buildTestButton(
              context,
              testType: 'Habilitats pràctiques', 
              levels: ['Bàsic', 'Intermedi', 'Avançat'], 
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(BuildContext context, {required String testType, required List<String> levels}) {
    return ExpansionTile(
      title: Text(
        testType,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      children: levels.map((level) {
        return ListTile(
          title: Text(level),
          trailing: Text(
            testResults[testType]?[level] ?? 'No completat',
            style: TextStyle(
              color: (testResults[testType]?[level] == 'Completat') ? Colors.green : Colors.black,
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => _getTestScreen(testType, level),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _getTestScreen(String testType, String testLevel) {
    switch (testType) {
      case 'Coneixements Salut':
        if (testLevel == 'Bàsic') {
          return HealthKnowledgeTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completat';
              });
            },
          );
        } else if (testLevel == 'Intermedi') {
          return IntermediateHealthKnowledgeTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completat';
              });
            },
          );
        } else if (testLevel == 'Avançat') {
          return AdvancedHealthKnowledgeTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completat';
              });
            },
          );
        }
        break;
      case 'Coneixements d\'atenció':
        if (testLevel == 'Bàsic') {
          return BasicAttentionKnowledgeTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completat';
              });
            },
          );
        } else if (testLevel == 'Intermedi') {
          return IntermediateAttentionKnowledgeTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completat';
              });
            },
          );
        } else if (testLevel == 'Avançat') {
          return AdvancedAttentionKnowledgeTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completat';
              });
            },
          );
        }
        break;
      case 'Habilitats de comunicació':
        if (testLevel == 'Bàsic') {
          return BasicCommunicationSkillsTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completat';
              });
            },
          );
        } else if (testLevel == 'Intermedi') {
          return IntermediateCommunicationSkillsTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completat';
              });
            },
          );
        } else if (testLevel == 'Avançat') {
          return AdvancedCommunicationSkillsTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completat';
              });
            },
          );
        }
        break;
      case 'Habilitats pràctiques': 
        if (testLevel == 'Bàsic') { 
          return BasicPracticalSkillsTestScreen( 
            testType: testType, 
            testLevel: testLevel, 
            onCompleted: () { 
              setState(() { 
                testResults[testType]?[testLevel] = 'Completat'; 
              }); 
            }, 
          ); 
        } else if (testLevel == 'Intermedi') { 
          return IntermediatePracticalSkillsTestScreen( 
            testType: testType, 
            testLevel: testLevel, 
            onCompleted: () { 
              setState(() { 
                testResults[testType]?[testLevel] = 'Completat'; 
              }); 
            },  
          );   
        } else if (testLevel == 'Avançat') { 
          return AdvancedPracticalSkillsTestScreen( 
            testType: testType, 
            testLevel: testLevel, 
            onCompleted: () { 
              setState(() { 
                testResults[testType]?[testLevel] = 'Completat'; 
              }); 
            }, 
          ); 
        } 
        break; 
      default:
        return Container();
    }
    return Container(); // En caso de que no haya coincidencia
  }
}
















