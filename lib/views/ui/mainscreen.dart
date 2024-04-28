import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopshoes/controllers/mainscreen_provider.dart';
import 'package:shopshoes/views/shared/bottom_nav_widget.dart';
import 'package:shopshoes/views/ui/cart_page.dart';
import 'package:shopshoes/views/ui/favorites.dart';
import 'package:shopshoes/views/ui/home_page.dart';
import 'package:shopshoes/views/ui/product_by_cat.dart';
import 'package:shopshoes/views/ui/profile_page.dart';
import 'package:shopshoes/views/ui/search_page.dart';
import '../shared/appstyle.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../shared/botom_nav_widget.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  List<Widget> pageList = [
    const HomePage(),
    const SearchPage(),
    const Favorites(),
    CartPage(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenNotifier>(
      builder: (context, mainScreenNotifier, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFE2E2E2),
          body: pageList[mainScreenNotifier.pageIndex],
          bottomNavigationBar: const BottomNavBar(),
        );
      },
    );
  }
}
