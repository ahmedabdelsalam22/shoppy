import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_udgrade/shop/module/login/cubit/states.dart';
import 'package:shop_app_udgrade/shop/shared/network/api_const.dart';
import 'package:shop_app_udgrade/shop/shared/network/remote/dio_helper.dart';

import '../../../model/login_model.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool obscureText = true;

  void passWordSecure() {
    obscureText = !obscureText;
    emit(LoginPasswordSecureState());
  }

  LoginModel? loginModel;

  void userLogin({required String email, required String password}) {
    emit(LoginLoadingState());
    DioHelper.postData(url: ApiConstance.login, data: {
      'email': email,
      'password': password,
    }).then((value) {
      print(value.data);
      loginModel = LoginModel.fromJson(value.data);
      print(loginModel!.message);
      emit(LoginSuccessState(loginModel!));
    }).catchError((onError) {
      print(onError);
      emit(LoginErrorState(onError.toString()));
    });
  }
}
