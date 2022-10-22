import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_udgrade/shop/layout/shop_layout.dart';
import 'package:shop_app_udgrade/shop/module/login/cubit/cubit.dart';
import 'package:shop_app_udgrade/shop/module/login/cubit/states.dart';
import 'package:shop_app_udgrade/shop/shared/network/local/cache_helper.dart';
import 'package:shop_app_udgrade/shop/shared/style/color_manager.dart';

import '../../shared/components.dart';
import '../../shared/style/font_size_manager.dart';
import '../../shared/style/text_manager.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/LoginScreen';

  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            if (state.loginModel.status!) {
              print(state.loginModel.data!.token);

              String? token = state.loginModel.data!.token;

              CacheHelper.putString(key: 'token', value: token!).then((value) {
                pushNamedAndFinish(context, ShopLayout.routeName);
              });
            } else {
              print(state.loginModel.status);
              showToast(
                message: TextManager.loginFailed,
                color: ColorManager.red,
              );
            }
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);

          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          TextManager.login,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(fontSize: FontSizeManager.size35),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          TextManager.loginNowToApp,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: ColorManager.grey),
                        ),
                        const SizedBox(height: 30),
                        buildTextFormField(
                            controller: emailController,
                            inputType: TextInputType.emailAddress,
                            validate: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            label: TextManager.email,
                            prefixIcon: Icons.email_outlined,
                            obscureText: false),
                        const SizedBox(height: 15),
                        buildTextFormField(
                          controller: passwordController,
                          inputType: TextInputType.visiblePassword,
                          obscureText: cubit.obscureText,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a valid password';
                            } else if (value.length < 6) {
                              return 'Password must be 6 characters';
                            } else {
                              return null;
                            }
                          },
                          label: TextManager.password,
                          prefixIcon: Icons.lock,
                          suffix: GestureDetector(
                            onTap: cubit.passWordSecure,
                            child: Icon(
                              cubit.obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off_sharp,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) {
                            return defaultButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                },
                                text: TextManager.login);
                          },
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              TextManager.iHaveNoAccount,
                            ),
                            defaultTextButton(
                                text: TextManager.register,
                                onPressed: () {
                                  pushNamed(context, RegisterScreen.routeName);
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
