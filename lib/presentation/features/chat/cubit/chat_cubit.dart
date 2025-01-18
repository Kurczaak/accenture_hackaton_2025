import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:accenture_hackaton_2025/presentation/features/appointment/model/appointment.dart';
import 'package:accenture_hackaton_2025/presentation/features/chat/model/message.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
  late bool _sttEnabled;

  Future<void> init() async {
    await Permission.microphone.request();
    _sttEnabled = await SpeechToText().initialize(
      onError: (error) => print(error),
      onStatus: (status) {
        if (status == 'done') {
          sendMessage(isOnboarding: false);
          SpeechToText().stop();
        }
      },
      debugLogging: true,
    );
  }

  List<ChatCompletionMessage> get stateMessages => state.messages.map((e) {
        if (e.isUser) {
          return ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.parts(
              [
                ChatCompletionMessageContentPart.text(
                  text: e.message,
                ),
                for (final image in e.images)
                  ChatCompletionMessageContentPart.image(
                    imageUrl: ChatCompletionMessageImageUrl(
                        url:
                            "data:image/jpg;base64,${base64Encode(image.readAsBytesSync())}"),
                  ),
              ],
            ),
            role: ChatCompletionMessageRole.user,
          );
        } else {
          return ChatCompletionMessage.assistant(
            content: e.message,
            role: ChatCompletionMessageRole.assistant,
          );
        }
      }).toList();

  ChatCompletionMessage get userMessage {
    final base64Images =
        state.images.map((e) => base64Encode(e.readAsBytesSync())).toList();

    return ChatCompletionMessage.user(
      content: ChatCompletionUserMessageContent.parts(
        [
          ChatCompletionMessageContentPart.text(
            text: state.sttText ?? state.userInput,
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
    final msgsCopy = [...stateMessages];
    final msgCopy = userMessage.copyWith();
    emit(
      state.copyWith(
        isSTT: false,
        sttText: null,
        userInput: '',
        messages: [
          ...state.messages,
          Message(
            message: state.sttText ?? state.userInput,
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
            ...msgsCopy,
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

    const tool = ChatCompletionTool(
        type: ChatCompletionToolType.function, function: function);

    // Ask for symptoms by creating the request for chat completion
    final res1 = await client.createChatCompletion(
      request: CreateChatCompletionRequest(
        model: const ChatCompletionModel.model(ChatCompletionModels.gpt4o),
        messages: [
          const ChatCompletionMessage.system(
            content:
                'You are a medical assistant that helps collect symptoms from users. Always use collect_symptoms function to collect symptoms.',
          ),
          const ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(
              'Please list the symptoms you are experiencing.',
            ),
          ),
          ...stateMessages,
        ],
        tools: [tool],
        toolChoice: const ChatCompletionToolChoiceOption.tool(
          ChatCompletionNamedToolChoice(
            type: ChatCompletionNamedToolChoiceType.function,
            function:
                ChatCompletionFunctionCallOption(name: 'collect_symptoms'),
          ),
        ),
      ),
    );
    if (res1.choices.first.message.toolCalls?.first.function.arguments ==
        null) {
      return;
    }
    // Parse the function arguments returned by the chat model
    final arguments = json.decode(
      res1.choices.first.message.toolCalls!.first.function.arguments,
    ) as Map<String, dynamic>;

    // Extract symptoms from the function arguments
    final List<String> symptoms =
        List<String>.from(arguments['symptoms'] ?? []);

    // Do something with the collected symptoms, like storing or processing them
    print('XXX Symptoms collected: $symptoms');

    emit(
      state.copyWith(
        symptoms: [...state.symptoms, ...symptoms],
      ),
    );
  }

  Future<void> toggleSpeechToText() async {
    if (state.isSTT) {
      await SpeechToText().stop();
      emit(state.copyWith(isSTT: false));
      return;
    } else if (_sttEnabled) {
      emit(state.copyWith(isSTT: true));
      await SpeechToText().listen(
        onResult: (result) {
          print('XDDDD ${result.recognizedWords}');
          emit(state.copyWith(sttText: result.recognizedWords, isSTT: true));
        },
      );
    }
  }

  Future<void> suggestAppointments() async {
    // 1. Define the function for suggesting appointments
    const function = FunctionObject(
      name: 'suggest_appointments',
      description:
          'Suggest up to 10 potential appointments based on user symptoms. '
          'Return an array of appointments with fields: '
          '[appointmentName, date, office, doctor].',
      parameters: {
        'type': 'object',
        'properties': {
          'appointments': {
            'type': 'array',
            'items': {
              'type': 'object',
              'properties': {
                'appointmentName': {'type': 'string'},
                'date': {
                  'type': 'string',
                  'format': 'date-time',
                  'description': 'Date/Time in ISO-8601 format'
                },
                'office': {'type': 'string'},
                'doctor': {'type': 'string'},
              },
              'required': [
                'appointmentName',
                'date',
                'office',
                'doctor',
              ],
            },
            'description':
                'A list of up to 10 appointments suggested for the given symptoms.',
          },
        },
        'required': ['appointments'],
      },
    );

    // 2. Create a tool out of this function
    const tool = ChatCompletionTool(
      type: ChatCompletionToolType.function,
      function: function,
    );

    // 3. Build your prompt with relevant context and your stored symptoms
    final symptomList = state.symptoms.join(', ');
    final prompt = 'The user has the following symptoms: $symptomList.\n'
        'Suggest up to 10 potential medical appointments that might be relevant, '
        'including realistic future dates, doctor names, office location/number, '
        'and a short appointment description (e.g., "Blood test").';

    // 4. Request the chat completion to invoke the `suggest_appointments` function
    final res = await client.createChatCompletion(
      request: CreateChatCompletionRequest(
        model: const ChatCompletionModel.model(ChatCompletionModels.gpt4o),
        messages: [
          const ChatCompletionMessage.system(
            content:
                'You are a medical assistant that suggests appointments based on user symptoms. '
                'Always use the suggest_appointments function to do so.',
          ),
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(prompt),
          ),
        ],
        tools: [tool],
        toolChoice: const ChatCompletionToolChoiceOption.tool(
          ChatCompletionNamedToolChoice(
            type: ChatCompletionNamedToolChoiceType.function,
            function:
                ChatCompletionFunctionCallOption(name: 'suggest_appointments'),
          ),
        ),
      ),
    );

    // 5. Check if the tool call has the arguments we need
    if (res.choices.isEmpty ||
        res.choices.first.message.toolCalls == null ||
        res.choices.first.message.toolCalls!.isEmpty) {
      return;
    }

    // 6. Parse the function arguments returned by the chat model
    final rawArguments =
        res.choices.first.message.toolCalls!.first.function.arguments;
    final Map<String, dynamic> arguments = json.decode(rawArguments);

    // 7. Extract the array of appointments from the function arguments
    final List<dynamic> rawAppointments = arguments['appointments'] ?? [];

    // 8. Convert each raw appointment to an Appointment object
    final List<Appointment> appointments = rawAppointments
        .map((apt) => Appointment.fromJson(apt as Map<String, dynamic>))
        .toList();

    // 9. Do something with the suggested appointments (store, display, etc.)
    // For now, we'll simply print them and emit them in state.
    for (var appointment in appointments) {
      print(
          'Suggested: ${appointment.appointmentName} with Dr. ${appointment.doctor} '
          'at ${appointment.office} on ${appointment.date}');
    }

    // If you want to store these in your state:
    emit(
      state.copyWith(appointments: [...appointments], symptoms: []),
    );
  }

  void clearState() {
    emit(const ChatState(messages: []));
  }

  void scheduleAppointment(Appointment appointment) {
    emit(
      state.copyWith(
        scheduledAppointments: [...state.scheduledAppointments, appointment],
      ),
    );
  }

  void unscheduleAppointment(Appointment appointment) {
    emit(
      state.copyWith(
        scheduledAppointments: [
          for (final apt in state.scheduledAppointments)
            if (apt != appointment) apt
        ],
      ),
    );
  }

  @override
  Future<void> close() async {
    chatStream?.cancel();

    // return super.close();
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
