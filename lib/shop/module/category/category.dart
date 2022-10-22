import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);

        return ListView.separated(
            itemBuilder: (context, index) =>
                buildCatItem(cubit.categoriesModel!.data!.data![index]),
            separatorBuilder: (context, index) => separatedDivider(),
            itemCount: cubit.categoriesModel!.data!.data!.length);
      },
    );
  }

  Widget buildCatItem(model) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image(
              image: NetworkImage(model.image),
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              model.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios)
          ],
        ),
      );
}
