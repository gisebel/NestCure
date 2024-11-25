import 'package:flutter/material.dart';
import 'package:nestcure/app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nestcure/basic_attention_knowledge_test.dart';
import 'package:nestcure/intermediate_health_knowledge_test.dart';
import 'package:nestcure/advanced_health_knowledge_test.dart';
import 'package:nestcure/basic_communication_skills_test.dart';
import 'package:nestcure/intermediate_attention_knowledge_test.dart';
import 'package:nestcure/advanced_attention_knowledge_test.dart';
import 'package:nestcure/basic_practical_skills_test.dart'; 
import 'package:nestcure/intermediate_communication_skills_test.dart';
import 'package:nestcure/advanced_communication_skills_test.dart';
import 'package:nestcure/intermediate_practical_skills_test.dart'; 
import 'package:nestcure/advanced_practical_skills_test.dart'; 
import 'package:nestcure/basic_health_knowledge_test.dart';

class KnowledgeTestsScreen extends StatefulWidget {
  const KnowledgeTestsScreen({super.key});

  @override
  _KnowledgeTestsScreenState createState() => _KnowledgeTestsScreenState();
}

class _KnowledgeTestsScreenState extends State<KnowledgeTestsScreen> {

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
        final testKey = _getTestKey(testType, level);

        return ListTile(
          title: Text(level),
          trailing: StreamBuilder<DocumentSnapshot>(
            stream: _getTestStatusStream(testKey),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('Cargando...');
              }
              final testStatus = snapshot.data?.get('tests.$testKey') ?? false;
              return Text(
                testStatus ? 'Completado' : 'No completado',
                style: TextStyle(
                  color: testStatus ? Colors.green : Colors.red,
                ),
              );
            },
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

  Stream<DocumentSnapshot> _getTestStatusStream(String testKey) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('usuarios').doc(user.uid);
      return userRef.snapshots();
    } else {
      return Stream.empty();
    }
  }

  Widget _getTestScreen(String testType, String testLevel) {
    final testKey = _getTestKey(testType, testLevel);

    return StreamBuilder<DocumentSnapshot>(
      stream: _getTestStatusStream(testKey),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final testStatus = snapshot.data?.get('tests.$testKey') ?? false;

        if (testStatus) {
          return TestCompletedScreen();
        } else {
          return _getTestWidget(testType, testLevel);
        }
      },
    );
  }

  Widget _getTestWidget(String testType, String testLevel) {
    switch (testType) {
      case 'Conocimientos de salud':
        if (testLevel == 'Básico') return BasicHealthKnowledgeTestScreen(
          testType: testType,
          testLevel: testLevel,
          onCompleted: () => _onCompleted(testType, testLevel),
        );
        if (testLevel == 'Intermedio') return IntermediateHealthKnowledgeTestScreen(
          testType: testType,
          testLevel: testLevel,
          onCompleted: () => _onCompleted(testType, testLevel),
        );
        if (testLevel == 'Avanzado') return AdvancedHealthKnowledgeTestScreen(
          testType: testType,
          testLevel: testLevel,
          onCompleted: () => _onCompleted(testType, testLevel),
        );
        break;
      case 'Conocimientos de atención':
        if (testLevel == 'Básico') return BasicAttentionKnowledgeTestScreen(
          testType: testType,
          testLevel: testLevel,
          onCompleted: () => _onCompleted(testType, testLevel),
        );
        if (testLevel == 'Intermedio') return IntermediateAttentionKnowledgeTestScreen(
          testType: testType,
          testLevel: testLevel,
          onCompleted: () => _onCompleted(testType, testLevel),
        );
        if (testLevel == 'Avanzado') return AdvancedAttentionKnowledgeTestScreen(
          testType: testType,
          testLevel: testLevel,
          onCompleted: () => _onCompleted(testType, testLevel),
        );
        break;
      case 'Habilidades de comunicación':
        if (testLevel == 'Básico') return BasicCommunicationSkillsTestScreen(
          testType: testType,
          testLevel: testLevel,
          onCompleted: () => _onCompleted(testType, testLevel),
        );
        if (testLevel == 'Intermedio') return IntermediateCommunicationSkillsTestScreen(
          testType: testType,
          testLevel: testLevel,
          onCompleted: () => _onCompleted(testType, testLevel),
        );
        if (testLevel == 'Avanzado') return AdvancedCommunicationSkillsTestScreen(
          testType: testType,
          testLevel: testLevel,
          onCompleted: () => _onCompleted(testType, testLevel),
        );
        break;
      case 'Habilidades prácticas':
        if (testLevel == 'Básico') return BasicPracticalSkillsTestScreen(
          testType: testType,
          testLevel: testLevel,
          onCompleted: () => _onCompleted(testType, testLevel),
        );
        if (testLevel == 'Intermedio') return IntermediatePracticalSkillsTestScreen(
          testType: testType,
          testLevel: testLevel,
          onCompleted: () => _onCompleted(testType, testLevel),
        );
        if (testLevel == 'Avanzado') return AdvancedPracticalSkillsTestScreen(
          testType: testType,
          testLevel: testLevel,
          onCompleted: () => _onCompleted(testType, testLevel),
        );
        break;
    }
    return Container();
  }

  Future<void> _onCompleted(String testType, String testLevel) async {
    final user = FirebaseAuth.instance.currentUser;
    String testKey = _getTestKey(testType, testLevel);

    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('usuarios').doc(user.uid);

      final testsRef = userRef.collection('tests');
      final testRef = testsRef.doc(testKey);

      await testRef.set({
        'completed': true,
        'date': Timestamp.now(),
      }, SetOptions(merge: true));
    }
  }

  String _getTestKey(String testType, String testLevel) {
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

class TestCompletedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text(
              '¡Felicidades! Ya has completado este test.',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}