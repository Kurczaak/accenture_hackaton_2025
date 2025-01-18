import 'package:accenture_hackaton_2025/config/app_theme.dart';
import 'package:flutter/material.dart';

class NewSymptomPage extends StatefulWidget {
  @override
  _NewSymptomPageState createState() => _NewSymptomPageState();
}

class _NewSymptomPageState extends State<NewSymptomPage> {
  TextEditingController _symptomController = TextEditingController();

  bool isRecording = false;

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _symptomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Symptom'),
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppTheme.backgroundColor,
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _symptomController,
                  minLines: 14,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    hintText:
                        'Enter your symptom details here or tap the mic button to record a voice message',
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      style: _buttonStyle,
                      onPressed: () {
                        // Handle attachment action
                      },
                    ),
                    Spacer(),
                    if (isRecording)
                      IconButton(
                        icon: const Icon(Icons.stop),
                        style: _stopButtonStyle,
                        onPressed: () {},
                      ),
                    if (!isRecording)
                      IconButton(
                        icon: const Icon(Icons.mic),
                        style: _buttonStyle,
                        onPressed: () {},
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  final _buttonStyle = const ButtonStyle(
    padding: WidgetStatePropertyAll(
      EdgeInsets.all(12),
    ),
    backgroundColor: WidgetStatePropertyAll(AppTheme.primaryColor),
    iconColor: WidgetStatePropertyAll(AppTheme.textColorLight),
  );

  final _stopButtonStyle = const ButtonStyle(
    padding: WidgetStatePropertyAll(
      EdgeInsets.all(12),
    ),
    backgroundColor: WidgetStatePropertyAll(AppTheme.errorColor),
    iconColor: WidgetStatePropertyAll(AppTheme.textColorLight),
  );
}
