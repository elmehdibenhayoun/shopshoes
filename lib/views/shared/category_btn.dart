import 'package:flutter/material.dart';
import 'package:shopshoes/views/shared/appstyle.dart';

class CategoryBtn extends StatelessWidget {
  const CategoryBtn(
      {super.key,
      this.onPressed,
      required this.buttonClr,
      required this.label});
  final void Function()? onPressed;
  final Color buttonClr;
  final String label;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width * 0.244,
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: buttonClr, style: BorderStyle.solid),
            borderRadius: const BorderRadius.all(Radius.circular(9))),
        child: Center(
          child: Text(
            label,
            style: appStyle(18, buttonClr, FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
