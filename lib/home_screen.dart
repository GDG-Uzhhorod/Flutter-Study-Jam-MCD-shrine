import 'package:flutter/material.dart';
import 'package:flutter_app_mcd/model/product.dart';
import 'package:flutter_app_mcd/provider/product_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'model/products_repository.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<ProductProvider>(
        builder: (context) => ProductProvider(),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('SHRINE'),
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                debugPrint('Menu button');
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  debugPrint('Seanrch button');
                },
              ),
              IconButton(
                icon: Icon(Icons.tune),
                onPressed: () {
                  debugPrint('Filter button');
                },
              ),
            ],
          ),
          body: Consumer(
            builder: (context, ProductProvider productProvider, _) {
              Widget current;
              switch (productProvider.status) {
                case Status.Load:
                  current = Center(child: CircularProgressIndicator());
                  productProvider.loadProductsList();
                  break;
                case Status.Done:
                  current = _buildBody(context);
                  break;
              }

              return current;
            },
          ),
        ));
  }

  List<Card> _buildGridCardsProvider(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return productProvider.products.map<Card>((item) {
      Product product = item;
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.asset(
                product.assetName,
                package: product.assetPackage,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(product.name),
                    Text(formatter.format(product.price)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildBody(BuildContext context) {
    List<Product> products = ProductsRepository.loadProducts(Category.all);

    return GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        childAspectRatio: 7.0 / 9.0,
        children: _buildGridCardsProvider(context));
  }

  List<Card> _buildGridCards(int count) {
    List<Card> cards = List.generate(
        count,
        (int index) => Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 18.0 / 11.0,
                    child: Image.network(
                      "https://i.pinimg.com/736x/2d/dc/25/2ddc25914e2ae0db5311ffa41781dda1.jpg",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Title $index'),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text('Secondary Title'),
                      ],
                    ),
                  )
                ],
              ),
            ));

    return cards;
  }
}
