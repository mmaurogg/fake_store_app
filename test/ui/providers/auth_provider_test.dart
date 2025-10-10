// Dart

import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_app/ui/providers/auth_provider.dart';
import 'package:fake_store_app/domain/usecases/auth_use_case.dart';
import 'package:fake_store_app/domain/usecases/user_use_case.dart';
import 'package:fake_store/fake_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthUseCase extends Mock implements AuthUseCase {}

class MockUserUseCase extends Mock implements UserUseCase {}

void main() {
  late MockAuthUseCase mockAuthUseCase;
  late MockUserUseCase mockUserUseCase;
  late ProviderContainer container;

  final testUser = User(username: 'test', password: '1234');

  setUp(() {
    mockAuthUseCase = MockAuthUseCase();
    mockUserUseCase = MockUserUseCase();

    container = ProviderContainer.test(
      overrides: [
        authUseCaseProvider.overrideWithValue(mockAuthUseCase),
        userUseCaseProvider.overrideWithValue(mockUserUseCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is unauthenticated and not loading', () {
    final state = container.read(authProvider);
    expect(state.isAuthenticated, false);
    expect(state.isLoading, false);
    expect(state.user, isNull);
    expect(state.error, isNull);
  });

  group("login", () {
    test('login success updates state to authenticated', () async {
      when(
        () => mockAuthUseCase.login(testUser.username!, testUser.password!),
      ).thenAnswer((_) async => Right('token'));

      final notifier = container.read(authProvider.notifier);
      await notifier.login(testUser);

      final state = container.read(authProvider);
      expect(state.isAuthenticated, true);
      expect(state.isLoading, false);
      expect(state.user, testUser);
      expect(state.error, isNull);
    });

    test('login failure updates state with error', () async {
      when(
        () => mockAuthUseCase.login('test', '1234'),
      ).thenAnswer((_) async => Left(ApiException('Login failed')));

      final notifier = container.read(authProvider.notifier);
      await notifier.login(testUser);

      final state = container.read(authProvider);
      expect(state.isAuthenticated, false);
      expect(state.isLoading, false);
      expect(state.error, 'Login failed');
    });
  });

  group("register", () {
    test('register success updates state to authenticated', () async {
      when(
        () => mockUserUseCase.addUser(testUser),
      ).thenAnswer((_) async => Right(testUser));

      final notifier = container.read(authProvider.notifier);
      await notifier.register(testUser);

      final state = container.read(authProvider);
      expect(state.isAuthenticated, true);
      expect(state.isLoading, false);
      expect(state.user, testUser);
      expect(state.error, isNull);
    });

    test('register failure updates state with error', () async {
      when(
        () => mockUserUseCase.addUser(testUser),
      ).thenAnswer((_) async => Left(ApiException('Register failed')));

      final notifier = container.read(authProvider.notifier);
      await notifier.register(testUser);

      final state = container.read(authProvider);
      expect(state.isAuthenticated, false);
      expect(state.isLoading, false);
      expect(state.error, 'Register failed');
    });
  });

  test('logout resets state', () async {
    when(
      () => mockAuthUseCase.login('test', '1234'),
    ).thenAnswer((_) async => Right('token'));

    final notifier = container.read(authProvider.notifier);
    await notifier.login(testUser);

    notifier.logout();

    final state = container.read(authProvider);
    expect(state.isAuthenticated, false);
    expect(state.isLoading, false);
    //expect(state.user, isNull);
    expect(state.error, isNull);
  });

  test('clearError sets error to null', () async {
    when(
      () => mockAuthUseCase.login('test', '1234'),
    ).thenAnswer((_) async => Left(ApiException('Login failed')));

    final notifier = container.read(authProvider.notifier);
    await notifier.login(testUser);

    notifier.clearError();

    final state = container.read(authProvider);
    expect(state.error, isNull);
  });
}
