import 'package:flutter/material.dart';

import '../utils/scale.dart';

class RoundedButton extends StatelessWidget {
  final Function onTap;
  final Text text;
  final Color backgroundColor;
  final bool? loading;
  const RoundedButton({
    Key? key,
    required this.backgroundColor,
    required this.onTap,
    required this.text,
    this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(scale(5.0)),
        ),
        height: 48.0,
        child: Center(
          child: this.loading == true
              ? Container(
                  height: scale(24.0),
                  width: scale(24.0),
                  child: CircularProgressIndicator())
              : text,
        ),
      ),
    );
  }
}
