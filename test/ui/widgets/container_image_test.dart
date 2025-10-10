import 'package:fake_store_app/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_app/ui/widgets/container_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  testWidgets('Muestra placeholder mientras carga la imagen', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ContainerImage(imageUrl: 'https://fakeurl.com/image.jpg'),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Muestra el errorWidget cuando la imagen falla', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ContainerImage(imageUrl: 'https://fakeurl.com/image.jpg'),
        ),
      ),
    );

    final widget = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );

    final errorWidgetBuilder = widget.errorWidget!;
    final errorWidget = errorWidgetBuilder(
      tester.element(find.byType(CachedNetworkImage)),
      'url',
      Exception(),
    );
    await tester.pumpWidget(MaterialApp(home: errorWidget));

    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    final image = tester.widget<Image>(find.byType(Image));
    final provider = image.image as AssetImage;
    expect(provider.assetName, Constants.noImageAsset);
  });
}
