import 'package:flutter/material.dart';
import 'package:kgf_app/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:kgf_app/features/crossfit/screens/class/widgets/vertical_expand_button.dart';
import 'package:kgf_app/utils/constants/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class TPrimaryHeaderContainer extends StatefulWidget {
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
    this.onCalendarFormatChanged,
    this.initialHeight = 225,
    this.expandable = true,
  });

  final double initialHeight;
  final Widget child;
  final Function(CalendarFormat)? onCalendarFormatChanged;
  final bool expandable;

  @override
  _TPrimaryHeaderContainerState createState() =>
      _TPrimaryHeaderContainerState();
}

class _TPrimaryHeaderContainerState extends State<TPrimaryHeaderContainer> {
  late double height;

  @override
  void initState() {
    super.initState();
    height = widget.initialHeight;
  }

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgeWidget(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: height,
        curve: Curves.easeInOut,
        child: Stack(
          children: [
            Container(
              color: TColors.primary,
              padding: const EdgeInsets.only(bottom: 0),
              child: widget.child,
            ),
            if (widget.expandable)
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy > 0) {
                      widget.onCalendarFormatChanged!(CalendarFormat.month);
                      setState(() {
                        height = 425;
                      });
                    } else if (details.delta.dy < 0) {
                      widget.onCalendarFormatChanged!(CalendarFormat.week);
                      setState(() {
                        height = 225;
                      });
                    }
                  },
                  onTap: () {
                    if (height == 225) {
                      widget.onCalendarFormatChanged!(CalendarFormat.month);
                      setState(() {
                        height = 425;
                      });
                    } else if (height == 425) {
                      widget.onCalendarFormatChanged!(CalendarFormat.week);
                      setState(() {
                        height = 225;
                      });
                    }
                  },
                  child: const VerticalExpandButton(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
