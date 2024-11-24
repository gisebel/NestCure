import 'package:flutter/material.dart';
import 'package:nestcure/app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'basic_attention_knowledge_test.dart';
import 'intermediate_health_knowledge_test.dart';
import 'advanced_health_knowledge_test.dart';
import 'basic_communication_skills_test.dart';
import 'intermediate_attention_knowledge_test.dart';
import 'advanced_attention_knowledge_test.dart';
import 'basic_practical_skills_test.dart'; 
import 'intermediate_communication_skills_test.dart';
import 'advanced_communication_skills_test.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tests de conocimiento',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
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
            onCompleted: () => _onCompleted(testType, testLevel),
          );
        } else if (testLevel == 'Intermedio') {
          return IntermediateHealthKnowledgeTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () => _onCompleted(testType, testLevel),
          );
        } else if (testLevel == 'Avanzado') {
          return AdvancedHealthKnowledgeTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () => _onCompleted(testType, testLevel),
          );
        }
        break;
      case 'Conocimientos de atención':
        if (testLevel == 'Básico') {
          return BasicAttentionKnowledgeTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () => _onCompleted(testType, testLevel),
          );
        } else if (testLevel == 'Intermedio') {
          return IntermediateAttentionKnowledgeTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () => _onCompleted(testType, testLevel),
          );
        } else if (testLevel == 'Avanzado') {
          return AdvancedAttentionKnowledgeTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () => _onCompleted(testType, testLevel),
          );
        }
        break;
      case 'Habilidades de comunicación':
        if (testLevel == 'Básico') {
          return BasicCommunicationSkillsTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () => _onCompleted(testType, testLevel),
          );
        } else if (testLevel == 'Intermedio') {
          return IntermediateCommunicationSkillsTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () => _onCompleted(testType, testLevel),
          );
        } else if (testLevel == 'Avanzado') {
          return AdvancedCommunicationSkillsTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () => _onCompleted(testType, testLevel),
          );
        }
        break;
      case 'Habilidades prácticas':
        if (testLevel == 'Básico') {
          return BasicPracticalSkillsTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () => _onCompleted(testType, testLevel),
          );
        } else if (testLevel == 'Intermedio') {
          return IntermediatePracticalSkillsTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () => _onCompleted(testType, testLevel),
          );
        } else if (testLevel == 'Avanzado') {
          return AdvancedPracticalSkillsTestScreen(
            testType: testType,
            testLevel: testLevel,
            onCompleted: () => _onCompleted(testType, testLevel),
          );
        }
        break;
      default:
        return Container();
    }
    return Container();
  }

  Future<void> _onCompleted(String testType, String testLevel) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('usuarios').doc(user.uid);
      try {
        // Actualizamos el estado del test en Firestore
        await userRef.update({
          'tests.${_getTestKey(testType, testLevel)}': true,  // Actualizamos el test específico
        });

        // También actualizamos el estado local
        setState(() {
          testResults[testType]?[testLevel] = 'Completado';
        });
      } catch (e) {
        print('Error al actualizar el estado del test: $e');
      }
    }
  }

  // Esta función genera la clave correspondiente para el test y nivel
  String _getTestKey(String testType, String testLevel) {
    // Dependiendo del tipo de test y nivel, se genera la clave correspondiente
    switch (testType) {
      case 'Conocimientos de salud':
        if (testLevel == 'Básico') return 'basicHealthKnowledgeTest';
        if (testLevel == 'Intermedio') return 'intermediateHealthKnowledgeTest';
        if (testLevel == 'Avanzado') return 'advancedHealthKnowledgeTest';
        break;
      case 'Conocimientos de atención':
        if (testLevel == 'Básico') return 'basicAttentionKnowledgeTest';
        if (testLevel == 'Intermedio') return 'intermediateAttentionKnowledgeTest';
        if (testLevel == 'Avanzado') return 'advancedAttentionKnowledgeTest';
        break;
      case 'Habilidades de comunicación':
        if (testLevel == 'Básico') return 'basicCommunicationSkillsTest';
        if (testLevel == 'Intermedio') return 'intermediateCommunicationSkillsTest';
        if (testLevel == 'Avanzado') return 'advancedCommunicationSkillsTest';
        break;
      case 'Habilidades prácticas':
        if (testLevel == 'Básico') return 'basicPracticalSkillsTest';
        if (testLevel == 'Intermedio') return 'intermediatePracticalSkillsTest';
        if (testLevel == 'Avanzado') return 'advancedPracticalSkillsTest';
        break;
    }
    return '';
  }
}