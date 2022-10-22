import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shop_app_udgrade/shop/layout/cubit/cubit.dart';
import 'package:shop_app_udgrade/shop/model/favorites_model.dart';
import 'package:shop_app_udgrade/shop/shared/style/color_manager.dart';
import 'package:shop_app_udgrade/shop/shared/style/text_manager.dart';

import '../../layout/cubit/states.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return ConditionalBuilder(
            condition: state is! ShopLoadingGetFavoritesState,
            builder: (context) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return buildListProduct(
                        cubit.favoritesModel!.data!.data![index], context);
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: cubit.favoritesModel!.data!.data!.length);
            },
            fallback: (context) => const Center(
                  child: CircularProgressIndicator(),
                ));
      },
    );
  }

  Widget buildListProduct(
    FavData favData,
    context,
  ) {
    int? discount = favData.product!.discount;
    dynamic oldPrice = favData.product!.oldPrice;
    bool idIsFound = ShopCubit.get(context).favorites[favData.product!.id]!;

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        width: 120,
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image(
                  image: NetworkImage('${favData.product!.image}'),
                  width: 120,
                  height: 120,
                ),
                if (discount != 0)
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
                    '${favData.product!.name}',
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
                        favData.product!.price.toString(),
                        style: const TextStyle(
                            fontSize: 12,
                            color: ColorManager.primarySwatchLight),
                      ),
                      const SizedBox(width: 10),
                      if (oldPrice != 0)
                        Text(
                          favData.product!.oldPrice.toString(),
                          style: const TextStyle(
                              fontSize: 10,
                              color: ColorManager.grey,
                              decoration: TextDecoration.lineThrough),
                        ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            ShopCubit.get(context)
                                .changeFavorites(favData.product!.id!);
                          },
                          icon: Icon(
                            idIsFound ? IconlyBold.heart : IconlyLight.heart,
                            color: ColorManager.primarySwatchLight,
                          ))
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
