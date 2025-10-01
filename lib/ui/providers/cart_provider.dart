import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/config/dependencies.dart';
import 'package:fake_store_app/ui/providers/auth_provider.dart';
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
        Cart? userCart;
        try {
          userCart = carts.firstWhere((element) => element?.userId == userId);
        } catch (e) {}

        if (userCart != null) {
          state = state.copyWith(cart: userCart, isLoading: false, error: null);
        } else {
          createNewCart();
        }
      },
    );
  }

  void createNewCart() {
    final userId = ref.watch(authProvider).user?.id ?? 0;
    Cart newCart = Cart(
      id: 11,
      userId: userId,
      date: DateTime.now(),
      products: [],
    );
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

  void removeProductFromCart(int? productId) {
    if (productId == null || state.cart!.products == null) return;

    final currentProducts = state.cart!.products!;
    final newProducts = List<CartProduct>.from(currentProducts);
    newProducts.removeWhere((element) => element.productId == productId);

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
