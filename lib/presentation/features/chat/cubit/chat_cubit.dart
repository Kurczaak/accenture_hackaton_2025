import 'dart:async';

import 'package:accenture_hackaton_2025/presentation/features/chat/model/message.dart';
import 'package:bloc/bloc.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'chat_cubit.freezed.dart';
part 'chat_state.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  ChatCubit()
      : super(const ChatState(
          messages: [],
        ));

  final client = OpenAI.instance.chat;

  OpenAIChatCompletionChoiceMessageModel get userMessage =>
      OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            state.userInput,
          ),
        ],
        role: OpenAIChatMessageRole.user,
      );

  StreamSubscription<OpenAIStreamChatCompletionModel>? chatStream;

  void writeMessage(String message) {
    emit(state.copyWith(userInput: message));
  }

  Future<void> sendMessage() async {
    await Future.delayed(const Duration(seconds: 1));
    chatStream?.cancel();
    chatStream = OpenAI.instance.chat
        .createStream(
          model: "gpt-4o",
          messages: [
            userMessage,
          ],
          seed: 423,
          n: 2,
        )
        .listen(onData, onDone: onDone);
    emit(state.copyWith(isLoading: true, userInput: ''));
  }

  void onData(OpenAIStreamChatCompletionModel data) {
    final currentLastMessage = state.lastMessage?.message ?? '';
    String newContent = '';
    for (final chunk
        in data.choices.firstWhereOrNull((e) => e.index == 0)?.delta.content ??
            <OpenAIChatCompletionChoiceMessageContentItemModel?>[]) {
      newContent += chunk?.text ?? '';
    }
    final combinedMessage = currentLastMessage + newContent;
    emit(state.copyWith(
      lastMessage: Message(message: combinedMessage),
    ));
  }

  void onDone() {
    emit(state.copyWith(
      lastMessage: null,
      messages: state.lastMessage != null
          ? [...state.messages, state.lastMessage!]
          : state.messages,
    ));
  }
}

extension IterableExt<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
