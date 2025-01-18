import 'package:accenture_hackaton_2025/config/app_theme.dart';
import 'package:accenture_hackaton_2025/di/injection.dart';
import 'package:accenture_hackaton_2025/presentation/features/chat/cubit/chat_cubit.dart';
import 'package:accenture_hackaton_2025/presentation/features/chat/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewSymptomPage extends StatefulWidget {
  @override
  _NewSymptomPageState createState() => _NewSymptomPageState();
}

class _NewSymptomPageState extends State<NewSymptomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Symptom'),
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: BlocProvider<ChatCubit>(
        create: (context) => getIt<ChatCubit>(),
        child: _PageBody(
          buttonStyle: _buttonStyle,
          stopButtonStyle: _stopButtonStyle,
          micButtonStyle: _micButtonStyle,
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

  final _micButtonStyle = const ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(AppTheme.errorColor),
    iconColor: WidgetStatePropertyAll(AppTheme.textColorLight),
  );
}

class _PageBody extends StatefulWidget {
  const _PageBody({
    super.key,
    required ButtonStyle buttonStyle,
    required ButtonStyle stopButtonStyle,
    required ButtonStyle micButtonStyle,
  })  : _buttonStyle = buttonStyle,
        _stopButtonStyle = stopButtonStyle,
        _micButtonStyle = micButtonStyle;

  final ButtonStyle _buttonStyle;
  final ButtonStyle _stopButtonStyle;
  final ButtonStyle _micButtonStyle;

  @override
  State<_PageBody> createState() => _PageBodyState();
}

class _PageBodyState extends State<_PageBody> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) => {
              if (state.lastMessage != null)
                {
                  _textController.clear(),
                }
            },
        builder: (context, state) {
          if (!state.isVoiceMode) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.messages.length +
                                (state.lastMessage != null ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (state.lastMessage != null &&
                                  index == state.messages.length) {
                                return _chatBubble(message: state.lastMessage!);
                              }
                              final message = state.messages[index];
                              return _chatBubble(message: message);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColorDark,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _textController,
                          onChanged: (value) {
                            context.read<ChatCubit>().writeMessage(value);
                          },
                          onSubmitted: (value) {
                            context.read<ChatCubit>().sendMessage();
                          },
                          minLines: state.messages.length > 1 ? 2 : 10,
                          maxLines: 10,
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
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.attach_file),
                              style: widget._buttonStyle,
                              onPressed: () {
                                // Handle attachment action
                              },
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(Icons.mic),
                              style: widget._buttonStyle,
                              onPressed: () {
                                context.read<ChatCubit>().toggleVoiceMode(true);
                              },
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.send),
                              style: widget._buttonStyle,
                              onPressed: () {
                                if (state.userInput.isNotEmpty) {
                                  context.read<ChatCubit>().sendMessage();
                                }
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Image.asset(
                    'assets/images/app/doctor.png',
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColorDark,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 32),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.attach_file),
                          style: widget._buttonStyle,
                          onPressed: () {
                            // Handle attachment action
                          },
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: IconButton(
                            icon: const Icon(Icons.mic_rounded),
                            style: widget._micButtonStyle,
                            onPressed: () {
                              if (state.userInput.isNotEmpty) {
                                context.read<ChatCubit>().sendMessage();
                              }
                            },
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.keyboard),
                          style: widget._buttonStyle,
                          onPressed: () {
                            context.read<ChatCubit>().toggleVoiceMode(false);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        });
  }

  _chatBubble({
    required Message message,
  }) {
    return ListTile(
      title: Align(
        alignment: (message.isUser ?? false)
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: (message.isUser ?? false)
                ? AppTheme.primaryColorLight
                : AppTheme.textHintColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              message.message,
              style: TextStyle(
                  color: (message.isUser ?? false)
                      ? AppTheme.textColorLight
                      : AppTheme.textColorDark),
            ),
          ),
        ),
      ),
    );
  }
}
