import 'package:chitter_chatter/features/user/domain/entities/contact_entity.dart';
import 'package:chitter_chatter/features/user/domain/repository/user_repository.dart';

class GetDeviceNumberUseCase {
  final UserRepository repository;

  GetDeviceNumberUseCase({required this.repository});

  Future<List<ContactEntity>> call() async {
    return repository.getDeviceNumber();
  }
}
