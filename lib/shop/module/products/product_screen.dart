import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shop_app_udgrade/shop/layout/cubit/cubit.dart';
import 'package:shop_app_udgrade/shop/layout/cubit/states.dart';
import 'package:shop_app_udgrade/shop/model/home_model.dart';
import 'package:shop_app_udgrade/shop/shared/components.dart';
import 'package:shop_app_udgrade/shop/shared/style/color_manager.dart';

import '../../model/categories_model.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessFavoritesState) {
          bool? status = state.favoritesModel.status;
          if (!status!) {
            showToast(
                message: '${state.favoritesModel.message}',
                color: ColorManager.red);
          }
          if (status) {
            showToast(
                message: '${state.favoritesModel.message}',
                color: ColorManager.green);
          }
        }
      },
      builder: (context, state) {
        var cubit = ShopCubit.get(context);

        return ConditionalBuilder(
            condition: cubit.homeModel != null && cubit.categoriesModel != null,
            builder: (context) {
              return productsBuilder(
                  cubit.homeModel, cubit.categoriesModel, context);
            },
            fallback: (context) => const Center(
                  child: CircularProgressIndicator(),
                ));
      },
    );
  }

  Widget productsBuilder(
      HomeModel? model, CategoriesModel? categoriesModel, context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CarouselSlider(
              items: model!.data!.banners!
                  .map((e) => Image(
                        image: NetworkImage('${e.image}'),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ))
                  .toList(),
              options: CarouselOptions(
                  enableInfiniteScroll: true,
                  viewportFraction: 0.9,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal)),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 100,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return buildCategoryItem(
                          categoriesModel.data!.data![index]);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 10.0,
                      );
                    },
                    itemCount: categoriesModel!.data!.data!.length,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'New Products',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
                mainAxisSpacing: 1,
                crossAxisSpacing: 1.0,
                childAspectRatio: 1 / 1.6,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                children: List.generate(model.data!.products!.length, (index) {
                  return buildProductItem(
                      model.data!.products![index], context);
                })),
          ),
        ],
      ),
    );
  }

  Widget buildProductItem(Products? model, context) {
    var cubit = ShopCubit.get(context);
    bool inFav = cubit.favorites[model!.id]!;

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image(
                image: NetworkImage('${model!.image}'),
                width: double.infinity,
                height: 200,
              ),
              if (model.discount != 0)
                Container(
                  color: Colors.red,
                  child: const Text(
                    'Discount',
                    style: TextStyle(fontSize: 8, color: Colors.white),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
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
                Row(
                  children: [
                    Text(
                      '${model.price!.round()}',
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                    const SizedBox(width: 10),
                    if (model.discount != 0)
                      Text(
                        '${model.oldPrice!.round()}',
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          cubit.changeFavorites(model.id!);
                        },
                        icon: Icon(
                          inFav ? IconlyBold.heart : IconlyLight.heart,
                          color: ColorManager.primarySwatchLight,
                        ))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryItem(data) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Image(
          image: NetworkImage(data.image),
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        Container(
            color: Colors.black.withOpacity(.8),
            width: 100,
            child: Text(
              data.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ))
      ],
    );
  }
}
