import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:kgf_app/common/widgets/login_signup/form_divider.dart";
import "package:kgf_app/features/personalization/controllers/session_controller.dart";
import "package:kgf_app/features/personalization/models/session_model.dart";
import 'package:kgf_app/features/personalization/screens/session/session_details_screen.dart';
import "package:kgf_app/features/personalization/screens/session/widgets/single_session.dart";
import "package:kgf_app/utils/constants/sizes.dart";
import "package:kgf_app/utils/constants/text_strings.dart";
import "package:kgf_app/utils/helpers/cloud_helper_functions.dart";
import "package:kgf_app/utils/helpers/helper_functions.dart";

class UserSessionScreen extends StatelessWidget {
  const UserSessionScreen({
    super.key,
    required this.focusedDay,
  });

  final DateTime focusedDay;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SessionController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      child: Obx(
        () {
          return FutureBuilder(
            key: Key(controller.refreshData.value.toString()),
            future: controller.getAllSessionsByDate(focusedDay),
            builder: (context, snapshot) {
              final response = TCloudHelperFunctions.checkMultiRecordState(
                  snapshot: snapshot);
              if (response != null) return response;

              final sessions = snapshot.data!;

              return Column(
                children: [
                  TFormDivider(
                      dividerText:
                          "${sessions.length} ${sessions.length > 1 ? TTexts.scheduledSessions.capitalize! : TTexts.scheduledSession.capitalize!}"),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: sessions.length,
                    itemBuilder: (_, index) => GestureDetector(
                      onTap: () => Get.to(() => SessionDetailsScreen(
                            session: sessions.elementAt(index),
                            disabledButtons:
                                isSessionDisabled(sessions.elementAt(index)),
                          )),
                      child: TSingleSession(
                        session: sessions.elementAt(index),
                        selectedSession: false,
                        disabled: isSessionDisabled(sessions.elementAt(index)),
                        iconsDisabled:
                            isSessionDisabled(sessions.elementAt(index)),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  bool isSessionDisabled(SessionModel session) {
    DateTime currentTime = THelperFunctions.getToday().toUtc();
    DateTime sessionDate =
        DateTime.fromMillisecondsSinceEpoch(session.date).toUtc();

    DateTime sessionTime = DateTime(
      sessionDate.year,
      sessionDate.month,
      sessionDate.day,
      int.parse(session.fromTime.split(':')[0]) - 2,
      int.parse(session.fromTime.split(':')[1]),
    );

    Duration difference = sessionTime.difference(currentTime);
    return difference.inMinutes <= -1440 || difference.inMinutes > -120;
  }
}
