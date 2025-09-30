import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/config/app_theme.dart';
import 'package:fake_store_app/ui/widgets/container_image.dart';
import 'package:flutter/material.dart';

class ShortCardWidget extends StatelessWidget {
  final GestureTapCallback? onTap;

  final Product product;
  const ShortCardWidget({super.key, this.onTap, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      product.title ?? '',
                      style: AppTheme().titleSmallStyle,
                      maxLines: 2,
                    ),
                    Text(
                      (product.price).toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme().themeApp.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8.0),
                height: 80,
                child: ContainerImage(imageUrl: product.image ?? ''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
