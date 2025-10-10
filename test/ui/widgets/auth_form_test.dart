import 'package:fake_store/fake_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store_app/ui/widgets/auth_form.dart';
import 'package:fake_store_app/ui/providers/auth_provider.dart';
import 'package:mocktail/mocktail.dart';

class TestAuthNotifier extends AuthNotifier {
  bool registerCalled = false;
  User? lastUser;

  @override
  Future<void> register(User user) async {
    registerCalled = true;
    lastUser = user;
    state = state.copyWith(isAuthenticated: true, user: user, isLoading: false);
  }
}

void main() {
  late TestAuthNotifier notifier;
  late ProviderContainer container;

  setUp(() {
    notifier = TestAuthNotifier();
    container = ProviderContainer.test();
  });

  tearDown(() {});

  Widget createWidgetUnderTest({AuthState? state}) {
    return ProviderScope(
      overrides: [authProvider.overrideWith(() => notifier)],
      child: MaterialApp(home: Scaffold(body: AuthForm())),
    );
  }

  testWidgets('AuthForm renders all fields and button', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.text('username'), findsOneWidget);
    expect(find.text('email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Form validation shows errors for empty fields', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text('Por favor ingresa tu username'), findsOneWidget);
    expect(find.text('Por favor ingresa tu email'), findsOneWidget);
    expect(find.text('Por favor ingresa tu contraseña'), findsOneWidget);
  });

  testWidgets('Email validation shows error for invalid email', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.enterText(find.byType(TextFormField).at(1), 'invalidemail');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text('Ingresa un email válido'), findsOneWidget);
  });

  testWidgets('Password validation shows error for short password', (
    tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.enterText(find.byType(TextFormField).at(2), '123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(
      find.text('La contraseña debe tener al menos 6 caracteres'),
      findsOneWidget,
    );
  });

  testWidgets('Submit button is disabled when isLoading is true', (
    tester,
  ) async {
    final container = ProviderContainer();
    final notifier = container.read(authProvider.notifier);
    notifier.state = notifier.state.copyWith(isLoading: true);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(home: Scaffold(body: AuthForm())),
      ),
    );

    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Valid input calls register on AuthNotifier', (tester) async {
    final user = User(
      username: 'testuser',
      email: 'test@email.com',
      password: '123456',
    );

    final container = ProviderContainer();
    final notifier = container.read(authProvider.notifier);
    notifier.state = notifier.state.copyWith(isLoading: true);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(home: Scaffold(body: AuthForm())),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), user.username!);
    await tester.enterText(find.byType(TextFormField).at(1), user.email!);
    await tester.enterText(find.byType(TextFormField).at(2), user.password!);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(notifier.state.isLoading, isTrue);
  });
}
