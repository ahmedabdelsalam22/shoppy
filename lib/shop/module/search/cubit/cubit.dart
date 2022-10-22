import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_udgrade/shop/model/searchModel.dart';
import 'package:shop_app_udgrade/shop/module/search/cubit/states.dart';
import 'package:shop_app_udgrade/shop/shared/network/api_const.dart';
import 'package:shop_app_udgrade/shop/shared/network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;

  void search({required String text}) {
    emit(SearchLoadingState());
    DioHelper.postData(
        url: ApiConstance.search,
        token: ApiConstance.token,
        data: {'text': text}).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((onError) {
      emit(SearchErrorState());
    });
  }
}
