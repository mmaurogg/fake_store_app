import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/ui/widgets/container_image.dart';
import 'package:flutter/material.dart';

class CustomCardView extends StatelessWidget {
  final GestureTapCallback? onTap;

  final Product product;
  CustomCardView({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Producto: " + product.title!), Text('Más...')],
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 250,
                width: double.infinity,
                child: ContainerImage(imageUrl: product.image ?? ''),
              ),
              SizedBox(height: 10),
              /* Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Origen: " + product.origin!),
                  Text("Inteligencia: " + product.intelligence!.toString()),
                ],
              ), */
            ],
          ),
        ),
      ),
    );
  }
}
