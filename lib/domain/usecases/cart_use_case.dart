import 'package:fake_store_app/config/dependencies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store/fake_store.dart';

final cartUseCaseProvider = Provider<CartUseCase>((ref) {
  final cartRepository = ref.watch(fakeStoreProvider).cart;
  return CartUseCase(cartRepository);
});

class CartUseCase {
  CartRepository cartRepository;

  CartUseCase(this.cartRepository);

  Future<Either<ApiException, List<Cart?>>> getAllCarts() {
    return cartRepository.getCarts();
  }

  Future<Either<ApiException, Cart?>> getUserCart(int userId) async {
    return getAllCarts().then((response) {
      return response.map((carts) {
        Cart? userCart;
        try {
          userCart = carts.firstWhere((element) => element?.userId == userId);
        } catch (e) {}

        return userCart;
      });
    });
  }

  Future<Either<ApiException, Cart?>> postCart(Cart cart) {
    return cartRepository.addCart(cart);
  }
}
