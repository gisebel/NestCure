import 'package:flutter/material.dart';
import 'package:nestcure/app_bar.dart';
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
    'Conocimientos de salud': {},
    'Conocimientos de atención': {},
    'Habilidades de comunicación': {},
    'Habilidades prácticas': {}, 
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, true),
      drawer: const NavigationDrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Tests de conocimiento',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _buildTestButton(
                context,
                testType: 'Conocimientos de salud',
                levels: ['Básico', 'Intermedio', 'Avanzado'],
              ),
              const SizedBox(height: 16),
              _buildTestButton(
                context,
                testType: 'Conocimientos de atención',
                levels: ['Básico', 'Intermedio', 'Avanzado'],
              ),
              const SizedBox(height: 16),
              _buildTestButton(
                context,
                testType: 'Habilidades de comunicación',
                levels: ['Básico', 'Intermedio', 'Avanzado'],
              ),
              const SizedBox(height: 16),
              _buildTestButton(
                context,
                testType: 'Habilidades prácticas',
                levels: ['Básico', 'Intermedio', 'Avanzado'],
              ),
              const SizedBox(height: 16),
            ],
          ),
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
            testResults[testType]?[level] ?? 'No completado',
            style: TextStyle(
              color: (testResults[testType]?[level] == 'Completado') ? Colors.green : Colors.black,
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
      case 'Conocimientos de salud':
        if (testLevel == 'Básico') {
          return BasicAttentionKnowledgeTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completado';
              });
            },
          );
        } else if (testLevel == 'Intermedio') {
          return IntermediateHealthKnowledgeTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completado';
              });
            },
          );
        } else if (testLevel == 'Avanzado') {
          return AdvancedHealthKnowledgeTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completado';
              });
            },
          );
        }
        break;
      case 'Conocimientos de atención':
        if (testLevel == 'Básico') {
          return BasicAttentionKnowledgeTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completado';
              });
            },
          );
        } else if (testLevel == 'Intermedio') {
          return IntermediateAttentionKnowledgeTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completado';
              });
            },
          );
        } else if (testLevel == 'Avanzado') {
          return AdvancedAttentionKnowledgeTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completado';
              });
            },
          );
        }
        break;
      case 'Habilidades de comunicación':
        if (testLevel == 'Básico') {
          return BasicCommunicationSkillsTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completado';
              });
            },
          );
        } else if (testLevel == 'Intermedio') {
          return IntermediateCommunicationSkillsTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completado';
              });
            },
          );
        } else if (testLevel == 'Avanzado') {
          return AdvancedCommunicationSkillsTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () {
              setState(() {
                testResults[testType]?[testLevel] = 'Completado';
              });
            },
          );
        }
        break;
      case 'Habilidades prácticas': 
        if (testLevel == 'Básico') { 
          return BasicPracticalSkillsTestScreen( 
            testType: testType, 
            testLevel: testLevel, 
            onCompleted: () { 
              setState(() { 
                testResults[testType]?[testLevel] = 'Completado'; 
              }); 
            }, 
          ); 
        } else if (testLevel == 'Intermedio') { 
          return IntermediatePracticalSkillsTestScreen( 
            testType: testType, 
            testLevel: testLevel, 
            onCompleted: () { 
              setState(() { 
                testResults[testType]?[testLevel] = 'Completado'; 
              }); 
            },  
          );   
        } else if (testLevel == 'Avanzado') { 
          return AdvancedPracticalSkillsTestScreen( 
            testType: testType, 
            testLevel: testLevel, 
            onCompleted: () { 
              setState(() { 
                testResults[testType]?[testLevel] = 'Completado'; 
              }); 
            }, 
          ); 
        } 
        break; 
      default:
        return Container();
    }
    return Container();
  }
}