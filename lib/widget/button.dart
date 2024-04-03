import 'package:flutter/material.dart';

import '../theme.dart';

class CustomAppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final MaterialStateProperty<Size> minSize;
  final MaterialStateProperty<Size> maxSize;
  final Color? backgroundColor;

  const CustomAppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.minSize,
    required this.maxSize,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            overflow: TextOverflow.visible),
        softWrap: false,
      ),
      style: ButtonStyle(
        minimumSize: minSize,
        maximumSize: maxSize,
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(backgroundColor ?? MaterialTheme.darkScheme().surfaceContainerHigh) ,
      ),
    );
  }
}
