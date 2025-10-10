import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/domain/usecases/user_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock para UserRepository
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late UserUseCase userUseCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    userUseCase = UserUseCase(mockUserRepository);
  });

  final tUser = User(
    id: 1,
    username: 'testuser',
    email: 'test@test.com',
    password: 'password',
  );
  final tException = ApiException('Failed to add user');

  group('addUser', () {
    test(
      'should call addUser on the repository and return a user on success',
      () async {
        // Arrange
        when(
          () => mockUserRepository.addUser(tUser),
        ).thenAnswer((_) async => Right(tUser));

        // Act
        final result = await userUseCase.addUser(tUser);

        // Assert
        expect(result, Right(tUser));
        verify(() => mockUserRepository.addUser(tUser)).called(1);
        verifyNoMoreInteractions(mockUserRepository);
      },
    );

    test('should return an ApiException when adding a user fails', () async {
      // Arrange
      when(
        () => mockUserRepository.addUser(tUser),
      ).thenAnswer((_) async => Left(tException));

      // Act
      final result = await userUseCase.addUser(tUser);

      // Assert
      expect(result, Left(tException));
      verify(() => mockUserRepository.addUser(tUser)).called(1);
      verifyNoMoreInteractions(mockUserRepository);
    });
  });
}
