import 'package:flutter/material.dart';

import '../../utils/constant_colors.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.cc,
    required this.title,
    required this.pressed,
    required this.asProvider,
  }) : super(key: key);

  final ConstantColors cc;
  final String title;
  final VoidCallback pressed;
  final asProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: cc.greyFour,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: pressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  asProvider.getString('See all'),
                  style: TextStyle(
                    color: cc.primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: cc.primaryColor,
                  size: 15,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
