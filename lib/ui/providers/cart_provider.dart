import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/config/dependencies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProvider = NotifierProvider<CartNotifier, CartState>(() {
  return CartNotifier();
});

class CartNotifier extends Notifier<CartState> {
  late FakeStore _fakeStore;

  @override
  CartState build() {
    _fakeStore = ref.watch(fakeStoreProvider);
    return CartState();
  }

  Future<void> getUserCart(int userId) async {
    state = state.copyWith(isLoading: true);
    var response = await _fakeStore.cart.getCarts();

    response!.fold(
      (error) {
        state = state.copyWith(isLoading: false, error: error.message);
      },
      (carts) {
        final userCart = carts.firstWhere(
          (element) => element?.userId == userId,
        );
        if (userCart != null) {
          state = state.copyWith(cart: userCart, isLoading: false, error: null);
        }
      },
    );
  }

  void createNewCart() {
    Cart newCart = Cart(id: 0, userId: 0, date: DateTime.now(), products: []);
    state = state.copyWith(isLoading: false, cart: newCart);
  }

  void addProductToCart(Product product) {
    if (product.id == null) return;

    if (state.cart == null) createNewCart();

    final currentProducts = state.cart!.products ?? [];
    final newProducts = List<CartProduct>.from(currentProducts);
    newProducts.add(CartProduct(productId: product.id!, quantity: 1));

    final updatedCart = state.cart!.copyWith(products: newProducts);
    state = state.copyWith(cart: updatedCart);
  }

  void removeProductFromCart(Product product) {
    if (product.id == null || state.cart!.products == null) return;

    final currentProducts = state.cart!.products!;
    final newProducts = List<CartProduct>.from(currentProducts);
    newProducts.removeWhere((element) => element.productId == product.id);

    final updatedCart = state.cart!.copyWith(products: newProducts);
    state = state.copyWith(cart: updatedCart);
  }
}

class CartState {
  final Cart? cart;
  final bool isLoading;
  final String? error;

  CartState({this.cart, this.isLoading = false, this.error});

  CartState copyWith({Cart? cart, bool? isLoading, String? error}) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
