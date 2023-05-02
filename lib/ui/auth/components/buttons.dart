import 'package:flutter/material.dart';

import '../../../constants.dart';

class BottomAuthButton extends StatelessWidget {
  const BottomAuthButton({
    super.key, required this.text, required this.onPressed,
  });

  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        border: Border.all(
          color: kPrimaryColor,
          width: 1.5,
        ),
      ),
      child: CustomButton(
        childText: text,
        onPressed: onPressed,
        backgroundColor: kPrimaryColor,
        roundBottom: false,
        roundTop: true,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.childText,
    required this.onPressed,
    required this.backgroundColor, required this.roundBottom, required this.roundTop,
  });

  final Function() onPressed;
  final Color backgroundColor;
  final String childText;
  final bool roundBottom;
  final bool roundTop;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: roundBottom ? const Radius.circular(28.0) : Radius.zero,
          bottomRight: roundBottom ? const Radius.circular(28.0) : Radius.zero,
          topRight: roundTop ? const Radius.circular(28.0) : Radius.zero,
          topLeft: roundTop ? const Radius.circular(28.0) : Radius.zero,
        ),
        color: backgroundColor,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          childText,
          style: const TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({Key? key,required this.text, required this.onPressed}) : super(key: key);
final Function() onPressed;
final String text;
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold),));
  }
}
