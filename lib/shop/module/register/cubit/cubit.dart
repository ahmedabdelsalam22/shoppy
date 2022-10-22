import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_udgrade/shop/module/register/cubit/states.dart';

import '../../../model/login_model.dart';
import '../../../shared/network/api_const.dart';
import '../../../shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialStates());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool obscureText = true;

  void passwordSecure() {
    obscureText = !obscureText;
    emit(RegisterPasswordSecureState());
  }

  LoginModel? loginModel;

  void userRegister(
      {required String email,
      required String password,
      required String name,
      required String phone}) {
    emit(RegisterLoadingState());
    DioHelper.postData(url: ApiConstance.register, data: {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    }).then((value) {
      print(value.data);
      loginModel = LoginModel.fromJson(value.data);
      print(loginModel!.message);
      emit(RegisterSuccessState(loginModel!));
    }).catchError((onError) {
      print(onError);
      emit(RegisterErrorState(onError.toString()));
    });
  }
}
