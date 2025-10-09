/* import 'package:fake_store/fake_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockFakeStore extends Mock implements FakeStore {}

class MockAuth extends Mock implements Auth {}

class MockUserApi extends Mock implements UserApi {}

void main() {
  late MockFakeStore mockFakeStore;
  late MockAuth mockAuth;
  late MockUserApi mockUserApi;
  late ProviderContainer container;

  setUp(() {
    mockFakeStore = MockFakeStore();
    mockAuth = MockAuth();
    mockUserApi = MockUserApi();

    when(mockFakeStore.auth).thenReturn(mockAuth);
    when(mockFakeStore.user).thenReturn(mockUserApi);

    container = ProviderContainer(
      overrides: [fakeStoreProvider.overrideWithValue(mockFakeStore)],
    );
  });

  test('initial state is unauthenticated', () {
    final state = container.read(authProvider);
    expect(state.isAuthenticated, false);
    expect(state.isLoading, false);
    expect(state.user, isNull);
    expect(state.error, isNull);
  });

  test('login success updates state', () async {
    final user = User(username: 'test', password: '1234');
    when(
      mockAuth.login(user.username!, user.password!),
    ).thenAnswer((_) async => Right('token'));

    await container.read(authProvider.notifier).login(user);

    final state = container.read(authProvider);
    expect(state.isAuthenticated, true);
    expect(state.isLoading, false);
    expect(state.user, user);
    expect(state.error, isNull);
  });

  test('login failure updates error', () async {
    final user = User(username: 'test', password: '1234');
    when(
      mockAuth.login(user.username!, user.password!),
    ).thenAnswer((_) async => Left(ApiError('Invalid')));

    await container.read(authProvider.notifier).login(user);

    final state = container.read(authProvider);
    expect(state.isAuthenticated, false);
    expect(state.isLoading, false);
    expect(state.error, 'Invalid');
  });

  test('register success updates state', () async {
    final user = User(username: 'test', password: '1234');
    when(mockUserApi.addUser(user)).thenAnswer((_) async => Right(user));

    await container.read(authProvider.notifier).register(user);

    final state = container.read(authProvider);
    expect(state.isAuthenticated, true);
    expect(state.isLoading, false);
    expect(state.user, user);
    expect(state.error, isNull);
  });

  test('register failure updates error', () async {
    final user = User(username: 'test', password: '1234');
    when(
      mockUserApi.addUser(user),
    ).thenAnswer((_) async => Left(ApiError('Register error')));

    await container.read(authProvider.notifier).register(user);

    final state = container.read(authProvider);
    expect(state.isAuthenticated, false);
    expect(state.isLoading, false);
    expect(state.error, 'Register error');
  });

  test('logout resets state', () {
    final notifier = container.read(authProvider.notifier);
    notifier.logout();
    final state = container.read(authProvider);
    expect(state.isAuthenticated, false);
    expect(state.user, isNull);
    expect(state.error, isNull);
  });

  test('clearError sets error to null', () {
    final notifier = container.read(authProvider.notifier);
    notifier.state = notifier.state.copyWith(error: 'Some error');
    notifier.clearError();
    expect(notifier.state.error, isNull);
  });
}
 */
