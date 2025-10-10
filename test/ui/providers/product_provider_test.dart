import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/domain/usecases/product_use_case.dart';
import 'package:fake_store_app/ui/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductUseCase extends Mock implements ProductUseCase {}

/* class Listener extends Mock {
  void call(ProductState? previous, ProductState next);
} */

void main() {
  late MockProductUseCase mockProductUseCase;
  // ignore: subtype_of_sealed_class

  late ProviderContainer container;

  final testProducts = [
    Product(id: 1, title: 'Product 1', price: 10.0),
    Product(id: 2, title: 'Product 2', price: 20.0),
  ];

  setUp(() {
    mockProductUseCase = MockProductUseCase();
    container = ProviderContainer.test(
      overrides: [productUseCaseProvider.overrideWithValue(mockProductUseCase)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is correct', () {
    final state = container.read(productProvider);
    expect(state.products, isEmpty);
    expect(state.isLoading, false);
    expect(state.error, isNull);
  });

  group('getAllProducts', () {
    test('success - loads products correctly', () async {
      when(
        () => mockProductUseCase.getAllProducts(),
      ).thenAnswer((_) async => Right(testProducts));

      /*       final listener = Listener();
      container.listen(productProvider, listener.call); */

      await container.read(productProvider.notifier).getAllProducts();

      /*       verifyInOrder([
        () =>
            listener(ProductState(), ProductState(isLoading: true)), // Loading
        () => listener(
          ProductState(isLoading: true),
          ProductState(isLoading: false, products: testProducts), // Success
        ),
      ]); */

      final state = container.read(productProvider);
      expect(state.isLoading, false);
      expect(state.products, testProducts);
      expect(state.error, isNull);
    });

    test('failure - updates state with error message', () async {
      final exception = ApiException('Failed to fetch products');
      when(
        () => mockProductUseCase.getAllProducts(),
      ).thenAnswer((_) async => Left(exception));

      await container.read(productProvider.notifier).getAllProducts();

      final state = container.read(productProvider);
      expect(state.isLoading, false);
      expect(state.products, isEmpty); // Products should remain empty on error
      expect(state.error, exception.message);
    });
  });
}
