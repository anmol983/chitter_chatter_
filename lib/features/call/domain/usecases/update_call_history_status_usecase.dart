import 'package:chitter_chatter/features/call/domain/entities/call_entity.dart';
import 'package:chitter_chatter/features/call/domain/repository/call_repository.dart';

class UpdateCallHistoryStatusUseCase {
  final CallRepository repository;

  const UpdateCallHistoryStatusUseCase({required this.repository});

  Future<void> call(CallEntity call) async {
    return await repository.updateCallHistoryStatus(call);
  }
}
