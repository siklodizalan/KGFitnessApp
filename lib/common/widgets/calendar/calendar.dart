import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:kgf_app/utils/constants/colors.dart';
import 'package:kgf_app/utils/constants/sizes.dart';
import 'package:kgf_app/utils/helpers/helper_functions.dart';
import 'package:table_calendar/table_calendar.dart';

class TTableCalendar extends StatefulWidget {
  const TTableCalendar({
    super.key,
    this.calendarFormat = CalendarFormat.week,
    required this.onFocusedDayChanged,
  });

  final CalendarFormat calendarFormat;
  final Function(DateTime) onFocusedDayChanged;

  @override
  _TTableCalendarState createState() => _TTableCalendarState();
}

class _TTableCalendarState extends State<TTableCalendar> {
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = THelperFunctions.getToday();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarFormat: widget.calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.monday,
      sixWeekMonthsEnforced: true,
      firstDay: DateTime.utc(2023, 12, 1),
      lastDay: DateTime.utc(2030, 1, 31),
      focusedDay: _focusedDay,
      rowHeight: 40,
      shouldFillViewport: false,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: TSizes.fontSizeLg,
          color: TColors.white,
        ),
        leftChevronIcon: Icon(Iconsax.arrow_left, color: TColors.white),
        rightChevronIcon: Icon(Iconsax.arrow_right_1, color: TColors.white),
      ),
      calendarStyle: const CalendarStyle(
        todayTextStyle: TextStyle(
          fontSize: TSizes.fontSizeMd,
          color: TColors.black,
        ),
        weekendTextStyle: TextStyle(
          fontSize: TSizes.fontSizeMd,
          color: TColors.white,
        ),
        defaultTextStyle: TextStyle(
          fontSize: TSizes.fontSizeMd,
          color: TColors.white,
        ),
        selectedTextStyle: TextStyle(
          fontSize: TSizes.fontSizeMd,
          color: TColors.black,
        ),
        selectedDecoration: BoxDecoration(
          color: TColors.white,
          shape: BoxShape.circle,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        dowTextFormatter: (date, locale) =>
            DateFormat.E(locale).format(date)[0],
        weekdayStyle: const TextStyle(
          color: TColors.white,
        ),
        weekendStyle: const TextStyle(
          color: TColors.white,
        ),
      ),
      selectedDayPredicate: (day) => isSameDay(day, _focusedDay),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
        widget.onFocusedDayChanged(focusedDay);
      },
      availableGestures: AvailableGestures.all,
    );
  }
}
