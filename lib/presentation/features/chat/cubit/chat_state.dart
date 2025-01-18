part of 'chat_cubit.dart';

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    required List<Message> messages,
    Message? lastMessage,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default(false) bool isFailure,
    @Default(false) bool isRecording,
    @Default(false) bool isVoiceMode,
    @Default('') String userInput,
    @Default([]) List<File> images,
    @Default([]) List<String> symptoms,
    @Default(false) bool isSTT,
    String? sttText,
    String? errorMessage,
  }) = _ChatState;
}
