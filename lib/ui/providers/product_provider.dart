import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/domain/usecases/product_use_case.dart';
import 'package:flutter_riverpod/legacy.dart';

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((
  ref,
) {
  final productUseCase = ref.watch(productUseCaseProvider);
  return ProductNotifier(productUseCase);
});

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductUseCase _productUseCase;

  ProductNotifier(this._productUseCase) : super(ProductState());

  Future<void> getAllProducts() async {
    state = state.copyWith(isLoading: true);
    var response = await _productUseCase.getAllProducts();
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

class ProductState {
  final List<Product?> products;
  final bool isLoading;
  final String? error;

  ProductState({this.products = const [], this.isLoading = false, this.error});

  ProductState copyWith({
    List<Product?>? products,
    bool? isLoading,
    String? error,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
