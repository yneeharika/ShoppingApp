import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingapp/proddetailscreen.dart';
import 'package:shoppingapp/providers/cart.dart';
import 'package:shoppingapp/providers/prodprov.dart';
import 'package:shoppingapp/screens/authscreen.dart';
import 'package:shoppingapp/screens/cartscreen.dart';
import 'package:shoppingapp/screens/editprodscreen.dart';
import 'package:shoppingapp/screens/orderscreen.dart';
import 'package:shoppingapp/screens/splashscreen.dart';
import 'package:shoppingapp/screens/userprodscreen.dart';
import 'providers/order.dart';
import 'providers/auth.dart';

Future<bool> checkuserlogin() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool isLoggedIn = pref.getBool('userLoggedIn') ?? false;
  return isLoggedIn;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( 
 
  );
  runApp(Myshop());
}

class Myshop extends StatelessWidget {
  const Myshop({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: checkuserlogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(body: CircularProgressIndicator()),
            );
          } else {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => Auth()),
                ChangeNotifierProvider(
                  create: (context) => Products(),
                ),
                ChangeNotifierProvider(
                  create: (context) => Cart(),
                ),
                ChangeNotifierProvider(
                  create: (context) => Orders(),
                ),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "Myshop",
                theme: ThemeData(
                  primaryColor: Colors.deepOrange,
                  primarySwatch: Colors.deepOrange,
                  fontFamily: "Lato",
                ),
                home:  AuthScreen(),
                routes: {
                  ProductDetailScreen.routeName: (context) =>
                      ProductDetailScreen(),
                  CartScreen.routeName: (context) => CartScreen(),
                  OrderScreen.routeName: (context) => OrderScreen(),
                  UserProductsScreen.routeName: (context) =>
                      UserProductsScreen(),
                  EditProductScreen.routeName: (context) => EditProductScreen(),
                },
              ),
            );
          }
        });
  }
}
