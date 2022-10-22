import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shop_app_udgrade/shop/layout/cubit/cubit.dart';
import 'package:shop_app_udgrade/shop/layout/cubit/states.dart';
import 'package:shop_app_udgrade/shop/shared/style/text_manager.dart';

import '../../shared/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../login/login_screen.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        var model = ShopCubit.get(context).userModel;

        nameController.text = model!.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;

        return ConditionalBuilder(
          condition: cubit.userModel != null,
          builder: (context) {
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://avatars.githubusercontent.com/u/75587814?s=400&u=185dbb0b60cf484314ea7973106982fe902069e1&v=4'),
                                fit: BoxFit.fill),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        if (state is ShopLoadingUpdateUserState)
                          const LinearProgressIndicator(),
                        const SizedBox(
                          height: 15,
                        ),
                        buildTextFormField(
                            controller: nameController,
                            obscureText: false,
                            inputType: TextInputType.text,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return TextManager.pleaseEnterName;
                              }
                              return null;
                            },
                            label: TextManager.userName,
                            prefixIcon: IconlyLight.profile),
                        const SizedBox(
                          height: 15,
                        ),
                        buildTextFormField(
                            controller: emailController,
                            obscureText: false,
                            inputType: TextInputType.emailAddress,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return TextManager.pleaseEnterEmailAddress;
                              }
                              return null;
                            },
                            label: TextManager.emailAddress,
                            prefixIcon: Icons.email_outlined),
                        const SizedBox(
                          height: 15,
                        ),
                        buildTextFormField(
                            controller: phoneController,
                            obscureText: false,
                            inputType: TextInputType.number,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return TextManager.pleaseEnterPhoneNumber;
                              }
                              return null;
                            },
                            label: TextManager.phone,
                            prefixIcon: Icons.phone),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultButton(
                            text: TextManager.update,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.updateUserData(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text);
                              }
                            }),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultButton(
                            text: TextManager.logOut,
                            onPressed: () {
                              CacheHelper.removeData(key: 'token')
                                  .then((value) {
                                if (value) {
                                  pushNamedAndFinish(
                                      context, LoginScreen.routeName);
                                }
                              });
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
