import 'package:chitter_chatter/features/call/domain/entities/call_entity.dart';
import 'package:chitter_chatter/features/call/domain/repository/call_repository.dart';

class GetUserCallingUseCase {
  final CallRepository repository;

  const GetUserCallingUseCase({required this.repository});

  Stream<List<CallEntity>> call(String uid) {
    return repository.getUserCalling(uid);
  }
}
