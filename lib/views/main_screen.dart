import 'package:app_web/views/side_bar_screens/buyers_screen.dart';
import 'package:app_web/views/side_bar_screens/category_screen.dart';
import 'package:app_web/views/side_bar_screens/orders_screen.dart';
import 'package:app_web/views/side_bar_screens/products_screen.dart';
import 'package:app_web/views/side_bar_screens/upload_banner_screen.dart';
import 'package:app_web/views/side_bar_screens/vendors_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedScreen = VendorsScreen();
  screenSelector(item) {
    switch (item.route) {
      case VendorsScreen.id:
        setState(() {
          _selectedScreen = VendorsScreen();
        });
        break;

      case BuyersScreen.id:
        setState(() {
          _selectedScreen = BuyersScreen();
        });
        break;

      case OrdersScreen.id:
        setState(() {
          _selectedScreen = OrdersScreen();
        });
        break;

      case CategoryScreen.id:
        setState(() {
          _selectedScreen = CategoryScreen();
        });
        break;

      case UploadBannerScreen.id:
        setState(() {
          _selectedScreen = UploadBannerScreen();
        });
        break;

      case ProductsScreen.id:
        setState(() {
          _selectedScreen = ProductsScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Management"),
      ),
      body: _selectedScreen,
      sideBar: SideBar(
        header: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black
          ),
          child: Center(
            child: Text("Multi Vendor Admin",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.7,
              color: Colors.white
            ),
            ),),
        )
        ,items: [
        AdminMenuItem(
            title: "Vendors", route: VendorsScreen.id, icon: Icons.person_2),
        AdminMenuItem(
            title: "Buyers", route: BuyersScreen.id, icon: Icons.person),
        AdminMenuItem(
            title: "Orders", route: OrdersScreen.id, icon: Icons.shopping_cart),
        AdminMenuItem(
            title: "Categories",
            route: CategoryScreen.id,
            icon: Icons.category),
        AdminMenuItem(
            title: "Upload Banners",
            route: UploadBannerScreen.id,
            icon: Icons.upload),
        AdminMenuItem(
            title: "Products", route: ProductsScreen.id, icon: Icons.store),
      ], selectedRoute: VendorsScreen.id,
      onSelected: (item){
        screenSelector(item);
      },
      ),
    );
  }
}
