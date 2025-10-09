import 'package:fake_store_app/config/dependencies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store/fake_store.dart';

final authUseCaseProvider = Provider<AuthUseCase>((ref) {
  final authRepository = ref.watch(fakeStoreProvider).auth;
  return AuthUseCase(authRepository);
});

class AuthUseCase {
  AuthRepository authRepository;

  AuthUseCase(this.authRepository);

  Future<Either<ApiException, String?>> login(
    String username,
    String password,
  ) {
    return authRepository.login(username, password);
  }
}
