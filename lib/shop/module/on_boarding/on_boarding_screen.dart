import 'package:flutter/material.dart';
import 'package:shop_app_udgrade/shop/module/login/login_screen.dart';
import 'package:shop_app_udgrade/shop/shared/network/local/cache_helper.dart';
import 'package:shop_app_udgrade/shop/shared/style/color_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../shared/components.dart';
import '../../shared/style/font_size_manager.dart';
import '../../shared/style/text_manager.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<BoardingModel> boardingData = [
    BoardingModel(
        image: TextManager.onBoardingImage, title: 'title 1', body: 'body 1'),
    BoardingModel(
        image: TextManager.onBoardingImage, title: 'title 2', body: 'body 2'),
    BoardingModel(
        image: TextManager.onBoardingImage, title: 'title 3', body: 'body 3'),
  ];

  var boardController = PageController();

  bool isLast = false;

  void submit() {
    CacheHelper.putBoolean(key: 'onBoarding', value: true).then((value) {
      if (value) {
        return pushNamedAndFinish(context, LoginScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              submit();
            },
            child: const Text(TextManager.skip),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: boardController,
                onPageChanged: (int index) {
                  if (index == boardingData.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, index) {
                  return buildBoardingItem(boardingData[index]);
                },
                itemCount: boardingData.length,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  effect: const ExpandingDotsEffect(
                      dotColor: ColorManager.grey,
                      activeDotColor: ColorManager.primarySwatchLight,
                      dotHeight: 10,
                      expansionFactor: 4,
                      dotWidth: 10,
                      spacing: 5.0),
                  count: boardingData.length,
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else {
                      boardController.nextPage(
                          duration: const Duration(milliseconds: 750),
                          curve: Curves.fastLinearToSlowEaseIn);
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel boardingData) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(image: AssetImage(boardingData.image)),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            boardingData.title,
            style: const TextStyle(
                fontSize: FontSizeManager.size24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            boardingData.body,
            style: const TextStyle(
                fontSize: FontSizeManager.size14, fontWeight: FontWeight.bold),
          ),
        ],
      );
}

class BoardingModel {
  final String image, title, body;

  BoardingModel({required this.image, required this.title, required this.body});
}
