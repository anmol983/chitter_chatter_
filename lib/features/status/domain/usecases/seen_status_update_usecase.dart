import 'package:chitter_chatter/features/status/domain/entities/status_entity.dart';
import 'package:chitter_chatter/features/status/domain/repository/status_repository.dart';

class SeenStatusUpdateUseCase {
  final StatusRepository repository;

  const SeenStatusUpdateUseCase({required this.repository});

  Future<void> call(String statusId, int imageIndex, String userId) async {
    return await repository.seenStatusUpdate(statusId, imageIndex, userId);
  }
}
