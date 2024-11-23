import 'package:chitter_chatter/features/chat/domain/entities/message_entity.dart';
import 'package:chitter_chatter/features/chat/domain/repository/chat_repository.dart';

class DeleteMessageUseCase {
  final ChatRepository repository;

  DeleteMessageUseCase({required this.repository});

  Future<void> call(MessageEntity message) async {
    return await repository.deleteMessage(message);
  }
}
