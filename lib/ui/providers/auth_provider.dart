import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/domain/usecases/auth_use_case.dart';
import 'package:fake_store_app/domain/usecases/user_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> {
  late AuthUseCase _authUseCase;
  late UserUseCase _userUseCase;

  @override
  AuthState build() {
    _authUseCase = ref.watch(authUseCaseProvider);
    _userUseCase = ref.watch(userUseCaseProvider);

    return AuthState();
  }

  Future<void> login(User user) async {
    state = state.copyWith(isLoading: true, error: null);
    var response = await _authUseCase.login(user.username!, user.password!);

    response.fold(
      (error) {
        state = state.copyWith(isLoading: false, error: (error.message));
      },
      (token) {
        if (token != null) {
          state = state.copyWith(
            isLoading: false,
            isAuthenticated: true,
            user: user,
            error: null,
          );
        }
      },
    );
  }

  Future<void> register(User user) async {
    state = state.copyWith(isLoading: true, error: null);

    var response = await _userUseCase.addUser(user);

    response.fold(
      (error) {
        state = state.copyWith(isLoading: false, error: error.message);
      },
      (userResponse) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: user,
          error: null,
        );
      },
    );
  }

  void logout() {
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: false,
      user: null,
      error: null,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final User? user;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    User? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error,
    );
  }
}
