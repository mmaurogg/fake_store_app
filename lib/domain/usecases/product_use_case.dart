import 'package:fake_store_app/config/dependencies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store/fake_store.dart';

final productUseCaseProvider = Provider<ProductUseCase>((ref) {
  final productRepository = ref.watch(fakeStoreProvider).product;
  return ProductUseCase(productRepository);
});

class ProductUseCase {
  ProductRepository productRepository;

  ProductUseCase(this.productRepository);

  Future<Either<ApiException, List<Product?>>> getAllProducts() {
    return productRepository.getProducts();
  }
}
