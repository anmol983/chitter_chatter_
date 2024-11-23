import 'package:chitter_chatter/features/user/domain/entities/user_entity.dart';
import 'package:chitter_chatter/features/user/domain/repository/user_repository.dart';

class GetAllUsersUseCase {
  final UserRepository repository;

  GetAllUsersUseCase({required this.repository});

  Stream<List<UserEntity>> call() {
    return repository.getAllUsers();
  }
}
