import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:kgf_app/common/widgets/appbar/appbar.dart";
import "package:kgf_app/common/widgets/login_signup/form_divider.dart";
import "package:kgf_app/common/widgets/login_signup/social_buttons.dart";
import "package:kgf_app/features/authentication/screens/signup/widgets/signup_form.dart";
import "package:kgf_app/utils/constants/sizes.dart";
import "package:kgf_app/utils/constants/text_strings.dart";

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(showBackArrow: true, title: Text('Sign Up')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(TTexts.signupTitle,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Form
              const TSignupForm(),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              /// Divider
              TFormDivider(dividerText: TTexts.orSignUpWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              /// Social Buttons
              const TSocialButtons(
                loaderText: TTexts.signingYouUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
