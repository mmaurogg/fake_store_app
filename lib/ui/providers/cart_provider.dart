import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/domain/usecases/cart_use_case.dart';
import 'package:fake_store_app/ui/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProvider = NotifierProvider<CartNotifier, CartState>(() {
  return CartNotifier();
});

class CartNotifier extends Notifier<CartState> {
  late CartUseCase _cartUseCase;

  @override
  CartState build() {
    _cartUseCase = ref.watch(cartUseCaseProvider);
    return CartState();
  }

  Future<void> getUserCart(int userId) async {
    state = state.copyWith(isLoading: true);
    var response = await _cartUseCase.getUserCart(userId);

    response.fold(
      (error) {
        state = state.copyWith(isLoading: false, error: error.message);
      },
      (userCart) {
        if (userCart != null) {
          state = state.copyWith(cart: userCart, isLoading: false, error: null);
        } else {
          createNewCart();
        }
      },
    );
  }

  Future<void> postUserCart(Cart cart) async {
    state = state.copyWith(isLoading: true);
    var response = await _cartUseCase.postCart(cart);

    response!.fold(
      (error) {
        state = state.copyWith(isLoading: false, error: error.message);
      },
      (cart) {
        if (cart != null) {
          createNewCart();
        } else {
          state = state.copyWith(isLoading: false, error: "algo salio mal");
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
