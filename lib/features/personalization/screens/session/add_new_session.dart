import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:iconsax/iconsax.dart";
import "package:kgf_app/common/widgets/appbar/appbar.dart";
import "package:kgf_app/common/widgets/texts/section_heading.dart";
import "package:kgf_app/utils/constants/sizes.dart";
import "package:kgf_app/utils/helpers/helper_functions.dart";

class AddNewSessionScreen extends StatefulWidget {
  const AddNewSessionScreen({super.key});

  @override
  _AddNewSessionScreenState createState() => _AddNewSessionScreenState();
}

class _AddNewSessionScreenState extends State<AddNewSessionScreen> {
  TimeOfDay? selectedFromTime;
  TimeOfDay? selectedToTime;
  DateTime? selectedDay = THelperFunctions.getToday();

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
    if (picked != null) {
      setState(() {
        if (isFrom) {
          selectedFromTime = picked;
        } else {
          selectedToTime = picked;
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

    if (picked != null) {
      setState(() {
        selectedDay = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'No repeat';
    return Scaffold(
      appBar:
          const TAppBar(showBackArrow: true, title: Text('Add new Session')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TSectionHeading(
                  title: "Title of the session:",
                  showActionButton: false,
                ),
                const SizedBox(height: TSizes.sm),
                TextFormField(
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
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(Iconsax.calendar_1),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  readOnly: true,
                  onTap: () {
                    _selectDate();
                  },
                  controller: TextEditingController(
                    text: selectedDay.toString().split(" ")[0],
                  ),
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
                            decoration: const InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.clock),
                              labelText: 'From',
                              suffixIcon: Icon(Icons.arrow_drop_down),
                            ),
                            controller: TextEditingController(
                              text: selectedFromTime != null
                                  ? '${selectedFromTime!.hour.toString().padLeft(2, '0')}:${selectedFromTime!.minute.toString().padLeft(2, '0')}'
                                  : '',
                            ),
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
                            decoration: const InputDecoration(
                                prefixIcon: Icon(CupertinoIcons.clock),
                                labelText: 'To',
                                suffixIcon: Icon(Icons.arrow_drop_down)),
                            controller: TextEditingController(
                              text: selectedToTime != null
                                  ? '${selectedToTime!.hour.toString().padLeft(2, '0')}:${selectedToTime!.minute.toString().padLeft(2, '0')}'
                                  : '',
                            ),
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
                  value: dropdownValue,
                  decoration:
                      const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
                  onChanged: (value) {},
                  items: [
                    'No repeat',
                    'Every Day',
                    'Every Weekday',
                    'Once a Week'
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
                        value: true,
                        onChanged: (value) {},
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
                      onPressed: () {}, child: const Text('Save')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
