import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kgf_app/utils/constants/colors.dart';

class TAddClassIcon extends StatelessWidget {
  const TAddClassIcon({
    super.key,
    this.iconColor = TColors.primary,
    required this.onPressed,
  });

  final Color? iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: TColors.white, borderRadius: BorderRadius.circular(100)),
      child: IconButton(
          onPressed: onPressed, icon: Icon(Iconsax.add, color: iconColor)),
    );
  }
}
