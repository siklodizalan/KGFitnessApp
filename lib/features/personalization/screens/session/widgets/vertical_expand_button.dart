import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class VerticalExpandButton extends StatelessWidget {
  const VerticalExpandButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      color: Colors.transparent,
      child: const Center(
        child: Icon(
          Iconsax.minus,
          color: Colors.white,
          size: 60,
        ),
      ),
    );
  }
}
