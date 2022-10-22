import '../../model/change_favorites_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class BottomNavBarTapState extends ShopStates {}

// Home data

class ShopLoadingHomeDataState extends ShopStates {}

class ShopSuccessHomeDataState extends ShopStates {}

class ShopErrorHomeDataState extends ShopStates {}

// categories

class ShopLoadingCategoriesState extends ShopStates {}

class ShopSuccessCategoriesState extends ShopStates {}

class ShopErrorCategoriesState extends ShopStates {}

// change favorites

class ShopChangeFavoritesState extends ShopStates {}

class ShopSuccessFavoritesState extends ShopStates {
  final ChangeFavoritesModel favoritesModel;

  ShopSuccessFavoritesState(this.favoritesModel);
}

class ShopErrorFavoritesState extends ShopStates {}

// get favorites

class ShopLoadingGetFavoritesState extends ShopStates {}

class ShopSuccessGetFavoritesState extends ShopStates {}

class ShopErrorGetFavoritesState extends ShopStates {}

// get profile

class ShopLoadingUserDataState extends ShopStates {}

class ShopSuccessUserDataState extends ShopStates {}

class ShopErrorUserDataState extends ShopStates {}

// update profile

class ShopLoadingUpdateUserState extends ShopStates {}

class ShopSuccessUpdateUserState extends ShopStates {}

class ShopErrorUpdateUserState extends ShopStates {}
