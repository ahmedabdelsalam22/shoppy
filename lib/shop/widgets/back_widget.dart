import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shop_app_udgrade/shop/shared/style/color_manager.dart';

class BackWidget extends StatelessWidget {
  const BackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.pop(context);
      },
      child: const Icon(
        IconlyLight.arrowLeft2,
        color: ColorManager.black,
      ),
    );
  }
}
