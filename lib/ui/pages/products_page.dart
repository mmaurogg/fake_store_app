import 'package:fake_store_app/ui/providers/fake_store_provider.dart';
import 'package:fake_store_app/ui/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final ScrollController _ScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final storeProvider = ref.watch(fakeStoreProvider);

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
                  controller: _ScrollController,
                  child: SingleChildScrollView(
                    controller: _ScrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...storeProvider.products.map(
                          (product) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomCardView(
                              product: product!,
                              onTap: () {},
                            ),
                          ),
                        ),
                        if (storeProvider.products.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        if (storeProvider.error != null)
                          Center(
                            child: Text(
                              'Error: ${storeProvider.products}',
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
