import 'package:shop_app_udgrade/shop/model/login_model.dart';

abstract class RegisterStates {}

class RegisterInitialStates extends RegisterStates {}

class RegisterPasswordSecureState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {
  final LoginModel loginModel;

  RegisterSuccessState(this.loginModel);
}

class RegisterErrorState extends RegisterStates {
  final String error;

  RegisterErrorState(this.error);
}
