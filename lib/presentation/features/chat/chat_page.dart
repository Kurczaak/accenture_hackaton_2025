import 'package:accenture_hackaton_2025/di/injection.dart';
import 'package:accenture_hackaton_2025/presentation/features/chat/cubit/chat_cubit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
        ),
        body: BlocProvider<ChatCubit>(
          create: (context) => getIt<ChatCubit>(),
          child: const _PageBody(),
        ));
  }
}

class _PageBody extends StatelessWidget {
  const _PageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    state.messages.length + (state.lastMessage != null ? 1 : 0),
                itemBuilder: (context, index) {
                  if (state.lastMessage != null &&
                      index == state.messages.length) {
                    return ListTile(
                      title: Text(state.lastMessage!.message),
                    );
                  }
                  final message = state.messages[index];
                  return ListTile(
                    title: Text(message.message),
                  );
                },
              ),
            ),
            SizedBox(
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        context.read<ChatCubit>().writeMessage(value);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<ChatCubit>().sendMessage();
                      },
                      child: const Text('Send'),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<ChatCubit>().addFile();
                      },
                      child: const Text('Upload image'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
