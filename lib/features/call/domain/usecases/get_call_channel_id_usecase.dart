import 'package:chitter_chatter/features/call/domain/repository/call_repository.dart';

class GetCallChannelIdUseCase {
  final CallRepository repository;

  const GetCallChannelIdUseCase({required this.repository});

  Future<String> call(String uid) async {
    return await repository.getCallChannelId(uid);
  }
}
