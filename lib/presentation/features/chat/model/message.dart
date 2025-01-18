import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

@freezed
abstract class Message with _$Message {
  const factory Message({
    required String message,
    required bool? isUser,
    List<String>? images,
  }) = _Message;
}
