import 'package:fake_store_app/config/dependencies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store/fake_store.dart';

final userUseCaseProvider = Provider<UserUseCase>((ref) {
  final userRepository = ref.watch(fakeStoreProvider).user;
  return UserUseCase(userRepository);
});

class UserUseCase {
  UserRepository userRepository;

  UserUseCase(this.userRepository);

  Future<Either<ApiException, User?>> addUser(User user) {
    return userRepository.addUser(user);
  }
}
