import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_udgrade/shop/module/login/login_screen.dart';
import 'package:shop_app_udgrade/shop/module/register/cubit/cubit.dart';
import 'package:shop_app_udgrade/shop/module/register/cubit/states.dart';

import '../../layout/shop_layout.dart';
import '../../shared/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/style/color_manager.dart';
import '../../shared/style/font_size_manager.dart';
import '../../shared/style/text_manager.dart';
import '../../widgets/back_widget.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = '/RegisterScreen';

  RegisterScreen({Key? key}) : super(key: key);

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            if (state.loginModel.status!) {
              // print(state.loginModel.data!.token);

              String? token = state.loginModel.data!.token;

              CacheHelper.putString(key: 'token', value: token!).then((value) {
                pushNamedAndFinish(context, ShopLayout.routeName);
              });
            } else {
              print(state.loginModel.status);
              showToast(
                message: TextManager.registerFailed,
                color: ColorManager.red,
              );
            }
          }
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              leading: const BackWidget(),
            ),
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
                          TextManager.register,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(fontSize: FontSizeManager.size35),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          TextManager.registerNowTo,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: ColorManager.grey),
                        ),
                        const SizedBox(height: 30),
                        buildTextFormField(
                            controller: nameController,
                            inputType: TextInputType.text,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a valid name';
                              }
                              return null;
                            },
                            label: TextManager.userName,
                            prefixIcon: Icons.person,
                            obscureText: false),
                        const SizedBox(height: 15),
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
                            controller: phoneController,
                            inputType: TextInputType.number,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                            label: TextManager.phone,
                            prefixIcon: Icons.call,
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
                            onTap: cubit.passwordSecure,
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
                          condition: state is! RegisterLoadingState,
                          builder: (context) {
                            return defaultButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.userRegister(
                                        name: nameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text,
                                        password: passwordController.text);
                                  }
                                },
                                text: TextManager.register);
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
                              TextManager.iHaveAccount,
                            ),
                            defaultTextButton(
                                text: TextManager.login,
                                onPressed: () {
                                  pushNamed(context, LoginScreen.routeName);
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
