import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/products_provider.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavourites;

  ProductsGrid(this.showOnlyFavourites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);

    final products =
        showOnlyFavourites ? productsData.favouriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, idx) => ChangeNotifierProvider.value(
        value: products[idx],
        child: ProductItem(),
      ),
    );
  }
}
