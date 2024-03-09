import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kgf_app/utils/constants/sizes.dart';

class TProfileMenu extends StatelessWidget {
  const TProfileMenu({
    super.key,
    this.onPressedIcon = Iconsax.arrow_right_34,
    required this.onPressed,
    required this.title,
    this.value,
    this.icon,
  });

  final IconData onPressedIcon;
  final IconData? icon;
  final VoidCallback onPressed;
  final String title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems / 1.5),
        child: Row(
          children: [
            if (icon != null) Expanded(child: Icon(icon, size: 18)),
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (value != null)
              Expanded(
                flex: 5,
                child: Text(
                  value!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Expanded(child: Icon(onPressedIcon, size: 18)),
          ],
        ),
      ),
    );
  }
}
