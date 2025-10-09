import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/config/app_theme.dart';
import 'package:fake_store_app/ui/providers/cart_provider.dart';
import 'package:fake_store_app/ui/widgets/container_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailPage extends ConsumerWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ContainerImage(imageUrl: product.image ?? ''),
                  ),
                ),
                SizedBox(height: 10),
                Text(product.title ?? '', style: AppTheme.titleStyle),
                SizedBox(height: 10),

                Row(
                  children: [
                    Text(
                      product.price.toString(),
                      style: AppTheme.titleSmallHighlightStyle,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(height: 10),

                Text(product.description ?? ''),

                SizedBox(height: 20),

                if (product.rating != null)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Rating: ",
                            style: AppTheme.titleSmallStyle,
                            children: [
                              WidgetSpan(
                                child: Icon(Icons.star, color: Colors.amber),
                              ),
                              TextSpan(text: product.rating!.rate.toString()),
                            ],
                          ),
                        ),
                        SizedBox(width: 50),
                        RichText(
                          text: TextSpan(
                            text: "Votes: ",
                            style: AppTheme.titleSmallStyle,
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.thumb_up,
                                  color:
                                      AppTheme().themeApp.colorScheme.primary,
                                ),
                              ),
                              TextSpan(text: product.rating!.count.toString()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ref.read(cartProvider.notifier).addProductToCart(product);
            Navigator.of(context).pop();
          },
          child: Icon(Icons.add_shopping_cart_outlined),
        ),
      ),
    );
  }
}
