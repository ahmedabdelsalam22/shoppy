import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app_udgrade/shop/shared/style/color_manager.dart';

void pushNamed(context, String routeName) {
  Navigator.pushNamed(context, routeName);
}

void pushNamedAndFinish(context, String routeName) {
  Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
}

Widget defaultTextButton({required Function onPressed, required String text}) {
  return TextButton(
      onPressed: () {
        onPressed();
      },
      child: Text(text));
}

Widget defaultButton({
  double width = double.infinity,
  double height = 55,
  Color background = ColorManager.primarySwatchLight,
  required Function onPressed,
  required String text,
}) {
  return Container(
    width: width,
    height: height,
    color: background,
    padding: const EdgeInsets.all(8.0),
    child: MaterialButton(
      onPressed: () {
        onPressed();
      },
      child: Text(
        text,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ),
  );
}

Widget buildTextFormField({
  required TextEditingController controller,
  required TextInputType inputType,
  required String? Function(String? val)? validate,
  required String label,
  required IconData prefixIcon,
  required bool obscureText,
  Widget? suffix,
  Function? onSubmit,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: inputType,
    validator: validate,
    onFieldSubmitted: (s) {
      onSubmit!(s);
    },
    decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        border: const OutlineInputBorder(),
        suffixIcon: suffix),
  );
}

void showToast({required String message, required Color color}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}

Widget separatedDivider() {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey[300],
    ),
  );
}
