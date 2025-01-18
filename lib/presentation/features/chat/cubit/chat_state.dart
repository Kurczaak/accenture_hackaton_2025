part of 'chat_cubit.dart';

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    required List<Message> messages,
    Message? lastMessage,
    @Default(false) bool isVoiceMode,
    @Default('') String userInput,
    @Default([]) List<File> images,
    @Default([]) List<String> symptoms,
    @Default(false) bool isSTT,
    @Default([]) List<Appointment> appointments,
    @Default([]) List<Appointment> scheduledAppointments,
    String? sttText,
    String? errorMessage,
  }) = _ChatState;
}
