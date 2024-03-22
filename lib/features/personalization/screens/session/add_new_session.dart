import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:kgf_app/common/widgets/appbar/appbar.dart";
import "package:kgf_app/common/widgets/texts/section_heading.dart";
import "package:kgf_app/features/personalization/controllers/session_controller.dart";
import "package:kgf_app/utils/constants/sizes.dart";
import "package:kgf_app/utils/helpers/helper_functions.dart";
import "package:kgf_app/utils/validators/validation.dart";

class AddNewSessionScreen extends StatefulWidget {
  const AddNewSessionScreen({
    super.key,
    this.sessionId,
    this.repeatId,
    this.editAllRepeat = false,
  });

  final String? sessionId;
  final String? repeatId;
  final bool editAllRepeat;

  @override
  _AddNewSessionScreenState createState() => _AddNewSessionScreenState();
}

class _AddNewSessionScreenState extends State<AddNewSessionScreen> {
  TimeOfDay? selectedFromTime;
  TimeOfDay? selectedToTime;
  DateTime? selectedDay = THelperFunctions.getToday();

  @override
  void initState() {
    super.initState();
    if (widget.sessionId == null || widget.sessionId == '') {
      final controller = Get.put(SessionController());
      controller.date.text = selectedDay.toString().split(" ")[0];
      controller.timeFrom.text = selectedFromTime != null
          ? '${selectedFromTime!.hour.toString().padLeft(2, '0')}:${selectedFromTime!.minute.toString().padLeft(2, '0')}'
          : '';
      controller.timeTo.text = selectedToTime != null
          ? '${selectedToTime!.hour.toString().padLeft(2, '0')}:${selectedToTime!.minute.toString().padLeft(2, '0')}'
          : '';
    }
  }

  Future<void> _selectTime(BuildContext context, bool isFrom) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    final controller = SessionController.instance;
    if (picked != null) {
      setState(() {
        if (isFrom) {
          selectedFromTime = picked;
          controller.timeFrom.text = selectedFromTime != null
              ? '${selectedFromTime!.hour.toString().padLeft(2, '0')}:${selectedFromTime!.minute.toString().padLeft(2, '0')}'
              : '';
        } else {
          selectedToTime = picked;
          controller.timeTo.text = selectedToTime != null
              ? '${selectedToTime!.hour.toString().padLeft(2, '0')}:${selectedToTime!.minute.toString().padLeft(2, '0')}'
              : '';
        }
      });
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime.utc(2023, 12, 1),
      lastDate: DateTime.utc(2030, 1, 31),
    );
    final controller = SessionController.instance;
    if (picked != null) {
      setState(() {
        selectedDay = picked;
        controller.date.text = picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = SessionController.instance;
    return Scaffold(
      appBar: TAppBar(
          showBackArrow: true,
          title: widget.sessionId == null || widget.sessionId == ''
              ? const Text('Add new Session')
              : const Text('Edit Session')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: controller.sessionFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TSectionHeading(
                  title: "Title of the session:",
                  showActionButton: false,
                ),
                const SizedBox(height: TSizes.sm),
                TextFormField(
                  controller: controller.title,
                  validator: (value) =>
                      TValidator.validateEmptyText('Title', value),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(CupertinoIcons.text_cursor),
                      labelText: 'Title'),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                const TSectionHeading(
                  title: "Date:",
                  showActionButton: false,
                ),
                const SizedBox(height: TSizes.sm),
                TextFormField(
                  enabled: (widget.sessionId == null || widget.sessionId == ''),
                  controller: controller.date,
                  validator: (value) =>
                      TValidator.validateEmptyText('Date', value),
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(Iconsax.calendar_1),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  readOnly: true,
                  onTap: () {
                    _selectDate();
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                const TSectionHeading(
                  title: "Time interval:",
                  showActionButton: false,
                ),
                const SizedBox(height: TSizes.sm),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectTime(context, true),
                        child: AbsorbPointer(
                          child: TextFormField(
                            validator: (value) =>
                                TValidator.validateEmptyText('Time', value),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.clock),
                              labelText: 'From',
                              suffixIcon: Icon(Icons.arrow_drop_down),
                            ),
                            controller: controller.timeFrom,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwInputFields),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectTime(context, false),
                        child: AbsorbPointer(
                          child: TextFormField(
                            validator: (value) =>
                                TValidator.validateEmptyText('Time', value),
                            decoration: const InputDecoration(
                                prefixIcon: Icon(CupertinoIcons.clock),
                                labelText: 'To',
                                suffixIcon: Icon(Icons.arrow_drop_down)),
                            controller: controller.timeTo,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                const TSectionHeading(
                  title: "Number of people:",
                  showActionButton: false,
                ),
                const SizedBox(height: TSizes.sm),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.minPeople,
                        validator: (value) => TValidator.validateEmptyText(
                            'Minimum number of people', value),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.chevron_forward),
                            labelText: 'Min'),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        controller: controller.maxPeople,
                        validator: (value) => TValidator.validateEmptyText(
                            'Maximum number of people', value),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.chevron_back),
                            labelText: 'Max'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                const TSectionHeading(
                  title: "Repeat:",
                  showActionButton: false,
                ),
                const SizedBox(height: TSizes.sm),
                DropdownButtonFormField(
                  value: controller.repeat.value,
                  decoration:
                      const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
                  onChanged:
                      (widget.sessionId != null && widget.sessionId != '')
                          ? null
                          : (value) {
                              setState(() {
                                controller.repeat.value = value.toString();
                              });
                            },
                  items: [
                    'No repeat',
                    'Every Day',
                    'Every Weekday',
                    'Once a Week',
                  ]
                      .map((option) =>
                          DropdownMenuItem(value: option, child: Text(option)))
                      .toList(),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                const TSectionHeading(
                  title: "Enable to bring a friend?",
                  showActionButton: false,
                ),
                const SizedBox(height: TSizes.sm),
                Row(
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: Checkbox(
                        value: controller.bringAFriend.value,
                        onChanged: (value) {
                          setState(() {
                            controller.bringAFriend.value = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems / 2),
                    const TSectionHeading(
                      title: "Enable",
                      showActionButton: false,
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () =>
                          (widget.sessionId != null && widget.sessionId != '')
                              ? controller.editSession(widget.editAllRepeat,
                                  widget.sessionId!, widget.repeatId!)
                              : controller.addNewSession(),
                      child: const Text('Save')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
