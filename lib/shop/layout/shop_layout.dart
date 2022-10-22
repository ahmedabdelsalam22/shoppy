import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shop_app_udgrade/shop/module/login/login_screen.dart';
import 'package:shop_app_udgrade/shop/shared/components.dart';
import 'package:shop_app_udgrade/shop/shared/network/local/cache_helper.dart';
import 'package:shop_app_udgrade/shop/shared/style/color_manager.dart';

import '../module/search/search_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ShopLayout extends StatelessWidget {
  static const String routeName = '/ShopLayout';

  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.logout,
                color: ColorManager.primarySwatchLight,
              ),
              onPressed: () {
                CacheHelper.removeData(key: 'token').then((value) {
                  if (value) {
                    pushNamedAndFinish(context, LoginScreen.routeName);
                  }
                });
              },
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    pushNamed(context, SearchScreen.routeName);
                  },
                  icon: const Icon(
                    Icons.search,
                    color: ColorManager.primarySwatchLight,
                  ))
            ],
          ),
          body: cubit.screen[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: cubit.bottomNavTap,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              elevation: 0.0,
              selectedItemColor: ColorManager.primarySwatchLight,
              unselectedItemColor: ColorManager.grey,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(cubit.currentIndex == 0
                        ? IconlyBold.home
                        : IconlyLight.home),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(cubit.currentIndex == 1
                        ? IconlyBold.category
                        : IconlyLight.category),
                    label: 'Categories'),
                BottomNavigationBarItem(
                    icon: Icon(cubit.currentIndex == 2
                        ? IconlyBold.heart
                        : IconlyLight.heart),
                    label: 'Favorites'),
                BottomNavigationBarItem(
                    icon: Icon(cubit.currentIndex == 3
                        ? IconlyBold.setting
                        : IconlyLight.setting),
                    label: 'Setting'),
              ]),
        );
      },
    );
  }
}
