import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_udgrade/shop/layout/cubit/cubit.dart';
import 'package:shop_app_udgrade/shop/layout/shop_layout.dart';
import 'package:shop_app_udgrade/shop/module/login/login_screen.dart';
import 'package:shop_app_udgrade/shop/module/on_boarding/on_boarding_screen.dart';
import 'package:shop_app_udgrade/shop/module/register/register_screen.dart';
import 'package:shop_app_udgrade/shop/module/search/search_screen.dart';
import 'package:shop_app_udgrade/shop/shared/network/api_const.dart';
import 'package:shop_app_udgrade/shop/shared/network/local/cache_helper.dart';
import 'package:shop_app_udgrade/shop/shared/network/remote/dio_helper.dart';
import 'package:shop_app_udgrade/shop/shared/style/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper.init();
  await CacheHelper.init();

  /*
  bool? isBoarding = CacheHelper.getBoolean(key: 'onBoarding');
  print(isBoarding);
  */

  String? token = CacheHelper.getString(key: 'token');
  print(token);

  // save to in external variable to use it in getHomeData from server.
  ApiConstance.token = token;

  runApp(MyApp(
    token: token,
  ));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({super.key, this.token});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ShopCubit()
              ..getHomeData()
              ..getCategories()
              ..getFavorites()
              ..getUserData())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: appLightTheme,
        home: token != null ? const ShopLayout() : const OnBoardingScreen(),
        routes: {
          LoginScreen.routeName: (ctx) => LoginScreen(),
          RegisterScreen.routeName: (ctx) => RegisterScreen(),
          ShopLayout.routeName: (ctx) => const ShopLayout(),
          SearchScreen.routeName: (ctx) => SearchScreen(),
        },
      ),
    );
  }
}
