import 'package:fake_store/fake_store.dart';
import 'package:flutter_riverpod/legacy.dart';

final fakeStoreProvider =
    StateNotifierProvider<FakeStoreNotifier, FakeStoreState>((ref) {
      final fakeStore = FakeStore();
      return FakeStoreNotifier(fakeStore);
    });

class FakeStoreNotifier extends StateNotifier<FakeStoreState> {
  final FakeStore _fakeStore;

  FakeStoreNotifier(this._fakeStore) : super(FakeStoreState()) {
    getAllProducts();
  }

  Future<void> getAllProducts() async {
    state = state.copyWith(isLoading: true);
    var response = await _fakeStore.product.getProducts();
    response.fold(
      (error) {
        state = state.copyWith(isLoading: false, error: error.message);
      },
      (products) {
        state = state.copyWith(isLoading: false, products: products);
      },
    );
  }
}

class FakeStoreState {
  final List<Product?> products;
  final bool isLoading;
  final String? error;

  FakeStoreState({
    this.products = const [],
    this.isLoading = false,
    this.error,
  });

  FakeStoreState copyWith({
    List<Product?>? products,
    bool? isLoading,
    String? error,
  }) {
    return FakeStoreState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
