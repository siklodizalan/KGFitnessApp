import 'package:flutter/material.dart';
import 'package:kgf_app/utils/constants/sizes.dart';
import 'package:kgf_app/utils/helpers/helper_functions.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.title,
    required this.subTitle,
    required this.image,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(children: [
        Image(
          width: THelperFunctions.screenWidth() * 0.8,
          height: THelperFunctions.screenHeight() * 0.6,
          image: AssetImage(image),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Text(
          subTitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }
}
