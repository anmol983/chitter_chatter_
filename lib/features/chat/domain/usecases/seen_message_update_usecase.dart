import 'package:chitter_chatter/features/chat/domain/entities/message_entity.dart';
import 'package:chitter_chatter/features/chat/domain/repository/chat_repository.dart';

class SeenMessageUpdateUseCase {
  final ChatRepository repository;

  SeenMessageUpdateUseCase({required this.repository});

  Future<void> call(MessageEntity message) async {
    return await repository.seenMessageUpdate(message);
  }
}
