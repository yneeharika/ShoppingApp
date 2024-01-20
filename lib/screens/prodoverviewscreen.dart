import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/providers/prodprov.dart';
import 'package:shoppingapp/screens/cartscreen.dart';
import 'package:shoppingapp/widgets/appdrawer.dart';
import 'package:shoppingapp/widgets/prodgrid.dart';

import '../providers/cart.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MyShop"), actions: <Widget>[
        PopupMenuButton(
          onSelected: (selectedvalue) {
            setState(() {
              if (selectedvalue == FilterOptions.Favorites) {
                _showOnlyFavorites = true;
              } else {
                _showOnlyFavorites = false;
              }
            });
          },
          icon: Icon(
            Icons.more_vert,
          ),
          itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<FilterOptions>>[
            const PopupMenuItem<FilterOptions>(
              value: FilterOptions.Favorites,
              child: Text("Only Favorites"),
            ),
            PopupMenuItem<FilterOptions>(
              value: FilterOptions.All,
              child: Text("Show All"),
            ),
          ],
        ),
        Consumer<Cart>(
          builder: (context, cart, ch) {
            return Badge(
                label: Text(cart.itemCount.toString()),
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ));
          },
        ),
      ]),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
