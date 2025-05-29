import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestSessionScreen extends StatefulWidget {
  const TestSessionScreen({super.key});

  @override
  State<TestSessionScreen> createState() => _TestSessionScreenState();
}

class _TestSessionScreenState extends State<TestSessionScreen> {
  String? sessionId;

  @override
  void initState() {
    super.initState();
    _loadSessionId();
  }

  Future<void> _loadSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionId = prefs.getString('session_id') ?? 'No session_id saved';
    });
  }

  Future<void> _saveDummySessionId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_id', 'dummy_session_123');
    _loadSessionId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Session ID')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Session ID: $sessionId'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveDummySessionId,
              child: const Text('Guardar session_id de prueba'),
            ),
          ],
        ),
      ),
    );
  }
}
