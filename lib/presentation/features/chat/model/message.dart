import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

@freezed
abstract class Message with _$Message {
  const factory Message({
    required String message,
    required bool isUser,
    @Default([]) List<File> images,
  }) = _Message;
}
