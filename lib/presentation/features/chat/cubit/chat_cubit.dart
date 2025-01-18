import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:accenture_hackaton_2025/presentation/features/chat/model/message.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:openai_dart/openai_dart.dart';

part 'chat_cubit.freezed.dart';
part 'chat_state.dart';

@singleton
class ChatCubit extends Cubit<ChatState> {
  ChatCubit()
      : super(const ChatState(
          messages: [],
        ));

  final client = OpenAIClient(apiKey: dotenv.get('OPEN_AI_KEY'));
  final ImagePicker picker = ImagePicker();

  ChatCompletionMessage get userMessage {
    final base64Images =
        state.images.map((e) => base64Encode(e.readAsBytesSync())).toList();

    return ChatCompletionMessage.user(
      content: ChatCompletionUserMessageContent.parts(
        [
          ChatCompletionMessageContentPart.text(
            text: state.userInput,
          ),
          for (final image in base64Images)
            ChatCompletionMessageContentPart.image(
              imageUrl: ChatCompletionMessageImageUrl(
                  url: "data:image/png;base64,$image"),
            ),
        ],
      ),
      role: ChatCompletionMessageRole.user,
    );
  }

  StreamSubscription<CreateChatCompletionStreamResponse>? chatStream;

  void writeMessage(String message) {
    emit(state.copyWith(userInput: message));
  }

  Future<void> addFile() async {
    picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        emit(
          state.copyWith(
            images: [
              ...state.images,
              File(value.path),
            ],
          ),
        );
      }
    });
  }

  Future<void> uploadPhoto() async {
    picker.pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        emit(
          state.copyWith(
            images: [
              ...state.images,
              File(value.path),
            ],
          ),
        );
      }
    });
  }

  Future<void> sendMessage({required bool isOnboarding}) async {
    final msgCopy = userMessage.copyWith();
    emit(
      state.copyWith(
        isLoading: true,
        userInput: '',
        messages: [
          ...state.messages,
          Message(
            message: state.userInput,
            isUser: true,
            images: state.images,
          )
        ],
        images: [],
      ),
    );

    if (isOnboarding) {
      await collectSymptoms();
    }

    await chatStream?.cancel();
    chatStream = client
        .createChatCompletionStream(
            request: CreateChatCompletionRequest(
          model: const ChatCompletionModel.model(
            ChatCompletionModels.gpt4o,
          ),
          messages: [
            msgCopy,
          ],
          seed: 423,
          n: 1,
        ))
        .listen(onData, onDone: onDone);
  }

  void onData(CreateChatCompletionStreamResponse data) {
    final currentLastMessage = state.lastMessage?.message ?? '';
    String newContent = '';

    newContent +=
        data.choices.firstWhereOrNull((e) => e.index == 0)?.delta.content ?? '';

    final combinedMessage = currentLastMessage + newContent;
    emit(state.copyWith(
      lastMessage: Message(message: combinedMessage, isUser: false),
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

  void toggleVoiceMode(bool isVoiceMode) {
    emit(state.copyWith(isVoiceMode: isVoiceMode));
  }

  Future<void> removeImage(int index) async {
    final images = [...state.images];
    images.removeAt(index);
    emit(state.copyWith(images: images));
  }

  Future<void> collectSymptoms() async {
    // Define the function for symptom collection
    const function = FunctionObject(
      name: 'collect_symptoms',
      description:
          'Ask the user to provide a list of symptoms they are experiencing',
      parameters: {
        'type': 'object',
        'properties': {
          'symptoms': {
            'type': 'array',
            'items': {
              'type': 'string',
            },
            'description': 'List of symptoms the user is experiencing',
          },
        },
        'required': ['symptoms'],
      },
    );

    // Ask for symptoms by creating the request for chat completion
    final res1 = await client.createChatCompletion(
      request: const CreateChatCompletionRequest(
        model: ChatCompletionModel.modelId('gpt-4o-mini'),
        messages: [
          ChatCompletionMessage.system(
            content:
                'You are a medical assistant that helps collect symptoms from users.',
          ),
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(
              'Please list the symptoms you are experiencing.',
            ),
          ),
        ],
        functions: [function],
      ),
    );

    // Parse the function arguments returned by the chat model
    final arguments = json.decode(
      res1.choices.first.message.functionCall!.arguments,
    ) as Map<String, dynamic>;

    // Extract symptoms from the function arguments
    final List<String> symptoms =
        List<String>.from(arguments['symptoms'] ?? []);

    // Do something with the collected symptoms, like storing or processing them
    print('XXX Symptoms collected: $symptoms');

    emit(
      state.copyWith(symptoms: [...state.symptoms, ...symptoms]),
    );
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
