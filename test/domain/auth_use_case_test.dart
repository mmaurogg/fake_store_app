import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/domain/usecases/auth_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock para AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthUseCase authUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authUseCase = AuthUseCase(mockAuthRepository);
  });

  group('AuthUseCase', () {
    const username = 'testuser';
    const password = 'password';
    const token = 'fake_token';
    final exception = ApiException('Login failed');

    test(
      'should call login on the repository with correct parameters',
      () async {
        // Arrange
        when(
          () => mockAuthRepository.login(any(), any()),
        ).thenAnswer((_) async => const Right(token));

        // Act
        await authUseCase.login(username, password);

        // Assert
        verify(() => mockAuthRepository.login(username, password)).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test('should return Right<String> when login is successful', () async {
      // Arrange
      when(
        () => mockAuthRepository.login(username, password),
      ).thenAnswer((_) async => const Right(token));
      // Act
      final result = await authUseCase.login(username, password);
      // Assert
      expect(result, const Right(token));
    });

    test('should return Left<ApiException> when login fails', () async {
      // Arrange
      when(
        () => mockAuthRepository.login(username, password),
      ).thenAnswer((_) async => Left(exception));
      // Act
      final result = await authUseCase.login(username, password);
      // Assert
      expect(result, Left(exception));
    });
  });
}
