import "package:flutter/material.dart";
import "package:kgf_app/common/styles/disabled_style.dart";
import "package:kgf_app/utils/constants/colors.dart";

class TSettingsMenuTile extends StatelessWidget {
  const TSettingsMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.trailing,
    this.onTap,
    this.disabled = false,
  });

  final IconData icon;
  final String title, subTitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool? disabled;

  @override
  Widget build(BuildContext context) {
    final TextStyle? disabledTitleStyle = DisabledStyle.getDisabledTextStyle(
        context, disabled!, Theme.of(context).textTheme.titleLarge);
    final TextStyle? disabledSubTitleStyle = DisabledStyle.getDisabledTextStyle(
        context, disabled!, Theme.of(context).textTheme.headlineMedium);
    final Color iconColor =
        disabled! ? Theme.of(context).disabledColor : TColors.primary;
    return ListTile(
      leading: Icon(icon, size: 32, color: iconColor),
      title: Text(
        title,
        style: disabledTitleStyle ?? Theme.of(context).textTheme.titleLarge!,
      ),
      subtitle: Text(
        subTitle,
        style: disabledSubTitleStyle ??
            Theme.of(context).textTheme.headlineMedium!,
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
