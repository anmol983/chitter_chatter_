import 'package:chitter_chatter/features/user/domain/entities/user_entity.dart';
import 'package:chitter_chatter/features/user/domain/repository/user_repository.dart';

class GetSingleUserUseCase {
  final UserRepository repository;

  GetSingleUserUseCase({required this.repository});

  Stream<List<UserEntity>> call(String uid) {
    return repository.getSingleUser(uid);
  }
}
