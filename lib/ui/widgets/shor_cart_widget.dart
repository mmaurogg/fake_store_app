import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/ui/widgets/container_image.dart';
import 'package:flutter/material.dart';

class ShorCartWidget extends StatelessWidget {
  final GestureTapCallback? onTap;

  final Product product;
  const ShorCartWidget({super.key, this.onTap, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: []),

            SizedBox(
              height: 50,
              child: ContainerImage(imageUrl: product.image ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}
