import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_udgrade/shop/module/search/cubit/cubit.dart';
import 'package:shop_app_udgrade/shop/module/search/cubit/states.dart';

import '../../shared/components.dart';
import '../../shared/style/color_manager.dart';
import '../../shared/style/text_manager.dart';

class SearchScreen extends StatelessWidget {
  static const String routeName = '/SearchScreen';

  SearchScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SearchCubit(),
        child: BlocConsumer<SearchCubit, SearchStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = SearchCubit.get(context);

            return Scaffold(
              appBar: AppBar(),
              body: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      buildTextFormField(
                          controller: searchController,
                          inputType: TextInputType.name,
                          onSubmit: (String text) {
                            cubit.search(text: text);
                          },
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a valid text';
                            }
                            return null;
                          },
                          label: TextManager.search,
                          prefixIcon: Icons.search,
                          obscureText: false),
                      const SizedBox(
                        height: 10,
                      ),
                      if (state is SearchLoadingState)
                        const LinearProgressIndicator(),
                      if (state is SearchSuccessState)
                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                return buildListProduct(
                                    SearchCubit.get(context)
                                        .searchModel!
                                        .data!
                                        .data![index],
                                    context);
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemCount: SearchCubit.get(context)
                                  .searchModel!
                                  .data!
                                  .data!
                                  .length),
                        )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget buildListProduct(model, context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SizedBox(
        width: 120,
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image(
                  image: NetworkImage(model.image),
                  width: 120,
                  height: 120,
                ),
                if (model.discount != 0)
                  Container(
                    color: ColorManager.red,
                    child: const Text(
                      TextManager.discount,
                      style: TextStyle(fontSize: 8, color: ColorManager.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      height: 1.3,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        model.price.toString(),
                        style: const TextStyle(
                            fontSize: 12,
                            color: ColorManager.primarySwatchLight),
                      ),
                      const SizedBox(width: 10),
                      if (model.oldPrice != 0)
                        Text(
                          model.oldPrice.toString(),
                          style: const TextStyle(
                              fontSize: 10,
                              color: ColorManager.grey,
                              decoration: TextDecoration.lineThrough),
                        ),
                      /* const Spacer(),
                      IconButton(
                          onPressed: (){
                            ShopCubit.get(context).changeFavorites(model.id!);
                          },
                          icon:  Icon(
                            idIsFound?
                            IconlyBold.heart : IconlyLight.heart,
                            color: ColorManager.primarySwatchLight,
                          )
                      )*/
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
