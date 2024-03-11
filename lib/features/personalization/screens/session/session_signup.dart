import "package:flutter/material.dart";
import 'package:kgf_app/common/widgets/calendar/calendar.dart';
import "package:kgf_app/common/widgets/custom_shapes/containers/primary_header_container.dart";
import "package:kgf_app/features/personalization/screens/session/widgets/session_signup_appbar.dart";
import "package:kgf_app/features/personalization/screens/session/session.dart";
import "package:kgf_app/utils/constants/sizes.dart";
import "package:kgf_app/utils/helpers/helper_functions.dart";
import "package:table_calendar/table_calendar.dart";

class SessionSignupScreen extends StatefulWidget {
  const SessionSignupScreen({super.key});

  @override
  _SessionSignupScreenState createState() => _SessionSignupScreenState();
}

class _SessionSignupScreenState extends State<SessionSignupScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = THelperFunctions.getToday();
  }

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
                  const TSessionSignupAppBar(),
                  TTableCalendar(
                    calendarFormat: _calendarFormat,
                    onFocusedDayChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections / 2),
            UserSessionScreen(focusedDay: _focusedDay),
          ],
        ),
      ),
    );
  }
}
