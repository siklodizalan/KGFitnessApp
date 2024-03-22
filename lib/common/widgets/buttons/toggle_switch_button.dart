import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kgf_app/features/personalization/controllers/session_controller.dart';

class ToggleSwitchButton extends StatefulWidget {
  const ToggleSwitchButton({
    super.key,
    required this.sessionId,
  });

  final String sessionId;

  @override
  _ToggleSwitchButtonState createState() => _ToggleSwitchButtonState();
}

class _ToggleSwitchButtonState extends State<ToggleSwitchButton> {
  bool isSwitched = true;

  @override
  void initState() {
    super.initState();
    fetchSessionData();
  }

  Future<void> fetchSessionData() async {
    SessionController controller = SessionController.instance;
    String fieldValue =
        await controller.getSessionSingleField(widget.sessionId, 'Active');
    setState(() {
      isSwitched = fieldValue == 'true';
    });
  }

  @override
  Widget build(BuildContext context) {
    SessionController controller = SessionController.instance;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SwitchListTile(
        title: Text(
          isSwitched
              ? 'This session is currently visible.'
              : 'This session is currently invisible.',
          style: const TextStyle(fontSize: 16),
        ),
        value: isSwitched,
        onChanged: (value) {
          setState(() {
            isSwitched = value;
          });
          controller.setSessionSingleField(widget.sessionId, {'Active': value});
        },
        secondary: Icon(
          isSwitched ? Iconsax.eye : Iconsax.eye_slash,
          color: isSwitched ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
