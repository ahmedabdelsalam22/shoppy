import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_udgrade/shop/layout/cubit/states.dart';
import 'package:shop_app_udgrade/shop/module/category/category.dart';
import 'package:shop_app_udgrade/shop/module/products/product_screen.dart';
import 'package:shop_app_udgrade/shop/module/settings/settings.dart';
import 'package:shop_app_udgrade/shop/shared/network/api_const.dart';
import 'package:shop_app_udgrade/shop/shared/network/remote/dio_helper.dart';

import '../../model/categories_model.dart';
import '../../model/change_favorites_model.dart';
import '../../model/favorites_model.dart';
import '../../model/home_model.dart';
import '../../model/login_model.dart';
import '../../module/favorites/favorites.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  ///////////////////////////////////////////////////////////
  int currentIndex = 0;

  void bottomNavTap(index) {
    currentIndex = index;
    emit(BottomNavBarTapState());
  }

  List<Widget> screen = [
    ProductScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingScreen()
  ];

  ////////////////////////////////////////////////////////

  HomeModel? homeModel;

  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url: ApiConstance.home,
      token: ApiConstance.token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      homeModel!.data!.products!.forEach((element) {
        favorites.addAll({element.id!: element.inFavorites!});
      });

      print(favorites);

      // print(value.data);
      // print(homeModel!.status);
      // print(homeModel!.data!.banners![0].image);
      emit(ShopSuccessHomeDataState());
    }).catchError((onError) {
      print(onError);
      emit(ShopErrorHomeDataState());
    });
  }

////////////////////////////////////////////////////////

  CategoriesModel? categoriesModel;

  void getCategories() {
    emit(ShopLoadingCategoriesState());
    DioHelper.getData(url: ApiConstance.categories).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      // print(categoriesModel);
      emit(ShopSuccessCategoriesState());
    }).catchError((onError) {
      print(onError);
      emit(ShopErrorCategoriesState());
    });
  }

////////////////////////////////////////////////////////

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    // make the heart btn change during btn
    favorites[productId] = !(favorites[productId]!);
    emit(ShopChangeFavoritesState());

    // add product to fav
    DioHelper.postData(
        url: ApiConstance.favorites,
        token: ApiConstance.token,
        data: {'product_id': productId}).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      //  print(changeFavoritesModel!.message);
      // print(value.data);

      getFavorites();
      // if status was null ,
      if (changeFavoritesModel!.status == false) {
        favorites[productId] = !(favorites[productId]!);
      }
      emit(ShopSuccessFavoritesState(changeFavoritesModel!));
    }).catchError((onError) {
      print(onError);
      // if was error .. we should retrieve btn to normal ..
      favorites[productId] = !(favorites[productId]!);
      emit(ShopErrorFavoritesState());
    });
  }

////////////////////////////////////////////////////////

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(url: ApiConstance.favorites, token: ApiConstance.token)
        .then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(ShopSuccessGetFavoritesState());
    }).catchError((onError) {
      print(onError);
      emit(ShopErrorGetFavoritesState());
    });
  }

//////////////////////////////////////////////////////////

  LoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingUserDataState());
    DioHelper.getData(url: ApiConstance.profile, token: ApiConstance.token)
        .then((value) {
      userModel = LoginModel.fromJson(value.data);
      // print(userModel!.data!.image);
      emit(ShopSuccessUserDataState());
    }).catchError((onError) {
      print(onError);
      emit(ShopErrorUserDataState());
    });
  }

//////////////////////////////////////////////////////////

  void updateUserData(
      {required String name, required String email, required String phone}) {
    emit(ShopLoadingUpdateUserState());
    DioHelper.putData(
        url: ApiConstance.updateProfile,
        token: ApiConstance.token,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
        }).then((value) {
      userModel = LoginModel.fromJson(value.data);
      // print(userModel!.data!.image);
      emit(ShopSuccessUpdateUserState());
    }).catchError((onError) {
      print(onError);
      emit(ShopErrorUpdateUserState());
    });
  }
}
