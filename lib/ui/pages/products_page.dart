import 'package:fake_store_app/ui/pages/product_detail_page.dart';
import 'package:fake_store_app/ui/providers/product_provider.dart';
import 'package:fake_store_app/ui/widgets/short_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productProvider);

    if (productsState.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (productsState.products.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('No hay productos para mostrar'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Scrollbar(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...productsState.products.map(
                          (product) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ShortCardWidget(
                              product: product!,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailPage(product: product),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        if (productsState.error != null)
                          Center(
                            child: Text(
                              'Error: ${productsState.products}',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
