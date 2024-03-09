import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:kgf_app/common/widgets/calendar/calendar.dart';
import "package:kgf_app/common/widgets/custom_shapes/containers/primary_header_container.dart";
import "package:kgf_app/common/widgets/login_signup/form_divider.dart";
import "package:kgf_app/features/crossfit/screens/class/widgets/class_signup_appbar.dart";
import "package:kgf_app/features/personalization/screens/session/session.dart";
import "package:kgf_app/utils/constants/sizes.dart";
import "package:kgf_app/utils/constants/text_strings.dart";
import "package:table_calendar/table_calendar.dart";

class ClassSignupScreen extends StatefulWidget {
  const ClassSignupScreen({super.key});

  @override
  _ClassSignupScreenState createState() => _ClassSignupScreenState();
}

class _ClassSignupScreenState extends State<ClassSignupScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              onCalendarFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              child: Column(
                children: [
                  const TClassSignupAppBar(),
                  TTableCalendar(
                    calendarFormat: _calendarFormat,
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections / 2),
            TFormDivider(
                dividerText: "x ${TTexts.scheduledSessions.capitalize!}"),
            const UserSessionScreen(),
          ],
        ),
      ),
    );
  }
}
