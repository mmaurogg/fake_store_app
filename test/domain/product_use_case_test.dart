import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/domain/usecases/product_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock para ProductRepository
class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductUseCase productUseCase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    productUseCase = ProductUseCase(mockProductRepository);
  });

  final tProducts = [
    Product(id: 1, title: 'Test Product 1', price: 100),
    Product(id: 2, title: 'Test Product 2', price: 200),
  ];
  final tException = ApiException('Failed to fetch products');

  group('getAllProducts', () {
    test('should get all products from the repository', () async {
      // Arrange
      when(
        () => mockProductRepository.getProducts(),
      ).thenAnswer((_) async => Right(tProducts));

      // Act
      final result = await productUseCase.getAllProducts();

      // Assert
      expect(result, Right(tProducts));
      verify(() => mockProductRepository.getProducts()).called(1);
      verifyNoMoreInteractions(mockProductRepository);
    });

    test('should return an ApiException when getting products fails', () async {
      // Arrange
      when(
        () => mockProductRepository.getProducts(),
      ).thenAnswer((_) async => Left(tException));

      // Act
      final result = await productUseCase.getAllProducts();

      // Assert
      expect(result, Left(tException));
      verify(() => mockProductRepository.getProducts()).called(1);
      verifyNoMoreInteractions(mockProductRepository);
    });
  });
}
