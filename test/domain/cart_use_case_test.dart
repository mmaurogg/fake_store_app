import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/domain/usecases/cart_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock para CartRepository
class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late CartUseCase cartUseCase;
  late MockCartRepository mockCartRepository;

  setUp(() {
    mockCartRepository = MockCartRepository();
    cartUseCase = CartUseCase(mockCartRepository);
  });

  final cart1 = Cart(id: 1, userId: 1, date: DateTime.now(), products: []);
  final cart2 = Cart(id: 2, userId: 2, date: DateTime.now(), products: []);
  final cartsList = [cart1, cart2];
  final exception = ApiException('Something went wrong');

  group('getAllCarts', () {
    test('should get all carts from the repository', () async {
      // Arrange
      when(
        () => mockCartRepository.getCarts(),
      ).thenAnswer((_) async => Right(cartsList));

      // Act
      final result = await cartUseCase.getAllCarts();

      // Assert
      expect(result, Right(cartsList));
      verify(() => mockCartRepository.getCarts()).called(1);
      verifyNoMoreInteractions(mockCartRepository);
    });

    test(
      'should return an ApiException when getting all carts fails',
      () async {
        // Arrange
        when(
          () => mockCartRepository.getCarts(),
        ).thenAnswer((_) async => Left(exception));

        // Act
        final result = await cartUseCase.getAllCarts();

        // Assert
        expect(result, Left(exception));
        verify(() => mockCartRepository.getCarts()).called(1);
        verifyNoMoreInteractions(mockCartRepository);
      },
    );
  });

  group('getUserCart', () {
    const tUserId = 1;

    test('should return a user cart when it exists', () async {
      // Arrange
      when(
        () => mockCartRepository.getCarts(),
      ).thenAnswer((_) async => Right(cartsList));

      // Act
      final result = await cartUseCase.getUserCart(tUserId);

      // Assert
      expect(result, Right(cart1));
      verify(() => mockCartRepository.getCarts()).called(1);
      verifyNoMoreInteractions(mockCartRepository);
    });

    test('should return null when user cart does not exist', () async {
      // Arrange
      when(
        () => mockCartRepository.getCarts(),
      ).thenAnswer((_) async => Right([cart2])); // List without user 1's cart

      // Act
      final result = await cartUseCase.getUserCart(tUserId);

      // Assert
      expect(result, const Right(null));
      verify(() => mockCartRepository.getCarts()).called(1);
      verifyNoMoreInteractions(mockCartRepository);
    });

    test('should return an ApiException when getting carts fails', () async {
      // Arrange
      when(
        () => mockCartRepository.getCarts(),
      ).thenAnswer((_) async => Left(exception));

      // Act
      final result = await cartUseCase.getUserCart(tUserId);

      // Assert
      expect(result, Left(exception));
      verify(() => mockCartRepository.getCarts()).called(1);
      verifyNoMoreInteractions(mockCartRepository);
    });
  });

  group('postCart', () {
    test('should call addCart on the repository', () async {
      // Arrange
      when(
        () => mockCartRepository.addCart(cart1),
      ).thenAnswer((_) async => Right(cart1));

      // Act
      final result = await cartUseCase.postCart(cart1);

      // Assert
      expect(result, Right(cart1));
      verify(() => mockCartRepository.addCart(cart1)).called(1);
      verifyNoMoreInteractions(mockCartRepository);
    });
  });
}
