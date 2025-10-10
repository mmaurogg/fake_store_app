import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/domain/usecases/cart_use_case.dart';
import 'package:fake_store_app/ui/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_store_app/ui/providers/cart_provider.dart';

class MockCartUseCase extends Mock implements CartUseCase {}

void main() {
  late MockCartUseCase mockCartUseCase;
  late ProviderContainer container;

  final testUser = User(id: 1, username: 'testuser');
  final testProduct = Product(id: 1, title: 'Test Product', price: 10.0);
  final testCart = Cart(
    id: 1,
    userId: testUser.id!,
    date: DateTime(1900, 1, 1),
    products: [CartProduct(productId: 0, quantity: 1)],
  );

  setUp(() {
    mockCartUseCase = MockCartUseCase();

    container = ProviderContainer.test(
      overrides: [cartUseCaseProvider.overrideWithValue(mockCartUseCase)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is correct', () {
    final state = container.read(cartProvider);
    expect(state.cart, isNull);
    expect(state.isLoading, false);
    expect(state.error, isNull);
  });

  group('getUserCart', () {
    test('success - user cart found', () async {
      when(
        () => mockCartUseCase.getUserCart(testUser.id!),
      ).thenAnswer((_) async => Right(testCart));

      await container.read(cartProvider.notifier).getUserCart(testUser.id!);

      final state = container.read(cartProvider);
      expect(state.isLoading, false);
      expect(state.cart, testCart);
      expect(state.error, isNull);
    });

    test('success - user cart not found, creates new cart', () async {
      when(
        () => mockCartUseCase.getUserCart(testUser.id!),
      ).thenAnswer((_) async => const Right(null));

      container.read(authProvider.notifier).state = AuthState(user: testUser);
      await container.read(cartProvider.notifier).getUserCart(testUser.id!);

      final state = container.read(cartProvider);
      expect(state.isLoading, false);
      expect(state.cart, isNotNull);
      expect(state.cart!.userId, testUser.id);
      expect(state.cart!.products, isEmpty);
    });

    test('failure - updates state with error', () async {
      final exception = ApiException('Failed to get cart');
      when(
        () => mockCartUseCase.getUserCart(testUser.id!),
      ).thenAnswer((_) async => Left(exception));

      await container.read(cartProvider.notifier).getUserCart(testUser.id!);

      final state = container.read(cartProvider);
      expect(state.isLoading, false);
      expect(state.error, exception.message);
      expect(state.cart, isNull);
    });
  });

  group('postUserCart', () {
    test('success - creates a new cart after posting', () async {
      when(
        () => mockCartUseCase.postCart(testCart),
      ).thenAnswer((_) async => Right(testCart));

      container.read(authProvider.notifier).state = AuthState(user: testUser);
      container.read(cartProvider.notifier).state = CartState(cart: testCart);

      await container.read(cartProvider.notifier).postUserCart(testCart);

      final state = container.read(cartProvider);
      expect(state.isLoading, false);
      expect(state.cart, isNotNull);
      expect(state.cart!.userId, testUser.id);
      expect(state.cart!.products, isEmpty);
    });

    test('failure - updates state with error', () async {
      final exception = ApiException('Failed to post cart');
      when(
        () => mockCartUseCase.postCart(testCart),
      ).thenAnswer((_) async => Left(exception));

      container.read(cartProvider.notifier).state = CartState(cart: testCart);

      await container.read(cartProvider.notifier).postUserCart(testCart);

      final state = container.read(cartProvider);
      expect(state.isLoading, false);
      expect(state.error, exception.message);
      expect(state.cart, testCart); // Cart should not be cleared on error
    });
  });

  group('addProductToCart', () {
    test('adds product to an existing cart', () {
      container.read(cartProvider.notifier).state = CartState(cart: testCart);

      container.read(cartProvider.notifier).addProductToCart(testProduct);

      final state = container.read(cartProvider);
      expect(state.cart!.products, hasLength(2));
      expect(state.cart!.products!.last.productId, testProduct.id);
    });

    test('creates a new cart and adds a product if cart is null', () {
      container.read(authProvider.notifier).state = AuthState(user: testUser);
      container.read(cartProvider.notifier).addProductToCart(testProduct);

      final state = container.read(cartProvider);
      expect(state.cart, isNotNull);
      expect(state.cart!.products, hasLength(1));
      expect(state.cart!.products!.first.productId, testProduct.id);
      expect(state.cart!.userId, testUser.id);
    });

    test('does not add product if product id is null', () {
      final productWithNullId = Product(title: 'No ID', price: 1.0);
      container.read(cartProvider.notifier).state = CartState(cart: testCart);

      container.read(cartProvider.notifier).addProductToCart(productWithNullId);

      final state = container.read(cartProvider);
      expect(state.cart!.products, hasLength(1)); // Should not have changed
    });
  });

  group('removeProductFromCart', () {
    test('removes an existing product from the cart', () {
      final productToRemove = CartProduct(
        productId: testProduct.id!,
        quantity: 1,
      );
      final initialCart = testCart.copyWith(
        products: [...testCart.products!, productToRemove],
      );
      container.read(cartProvider.notifier).state = CartState(
        cart: initialCart,
      );

      container
          .read(cartProvider.notifier)
          .removeProductFromCart(testProduct.id!);

      final state = container.read(cartProvider);
      expect(state.cart!.products, hasLength(1));
      expect(
        state.cart!.products!.any((p) => p.productId == testProduct.id!),
        isFalse,
      );
    });

    test('does nothing if product id is null', () {
      container.read(cartProvider.notifier).state = CartState(cart: testCart);
      final initialProducts = List.from(testCart.products!);

      container.read(cartProvider.notifier).removeProductFromCart(null);

      final state = container.read(cartProvider);
      expect(state.cart!.products, initialProducts);
    });
  });
}
