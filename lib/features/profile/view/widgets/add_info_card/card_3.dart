import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/add_info_viewmodel.dart';
import '../add_button.dart';
import '../custom_text_field.dart';

class Card3 extends StatefulWidget {
  final Color backgroundColor;
  final String title;
  final GlobalKey<FormState> formKey;

  const Card3({
    super.key,
    required this.backgroundColor,
    required this.title,
    required this.formKey,
  });

  @override
  State<Card3> createState() => _Card3State();
}

class _Card3State extends State<Card3> {
  late final addInfoViewModel =
      Provider.of<AddInfoViewmodel>(context, listen: false);

  void addEducation() {
    setState(() {
      addInfoViewModel.educationControllers.add({
        'instituteNameController': TextEditingController(),
        'courseNameController': TextEditingController(),
        'scoreController': TextEditingController(),
        'passYearController': TextEditingController(),
      });
    });
  }

  void removeEducation(int index) {
    setState(() {
      addInfoViewModel.educationControllers.removeAt(index);
    });
  }

  void datePicker(int index) async {
    final selectedDateText = addInfoViewModel
        .educationControllers[index]['passYearController']!
        .text;
    DateTime initialDate = DateTime.now();
    if (selectedDateText.isNotEmpty) {
      try {
        initialDate = DateFormat('MMM yyyy').parse(selectedDateText);
      } catch (_) {}
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1990),
      lastDate: DateTime(2050),
      helpText: 'Only Month and Year will be displayed',
    );

    if (pickedDate != null) {
      setState(() {
        addInfoViewModel.educationControllers[index]['passYearController']!
            .text = DateFormat('MMM yyyy').format(pickedDate);
      });
    }
  }

  Widget buildEducationForm(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: addInfoViewModel.educationControllers[index]
              ['instituteNameController']!,
          title: 'Institution Name',
          hintText: 'eg. Savitribai Phule Pune University',
        ),
        CustomTextField(
          controller: addInfoViewModel.educationControllers[index]
              ['courseNameController']!,
          title: 'Course Name',
          hintText: 'eg. Bachelors of Engineering',
        ),
        CustomTextField(
          controller: addInfoViewModel.educationControllers[index]
              ['scoreController']!,
          title: 'Score',
          hintText: 'eg. 9.84',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          maxLength: 4,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: () => datePicker(index),
            style: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.black87),
              backgroundColor: WidgetStatePropertyAll(Colors.white),
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_month, size: 18),
                const SizedBox(width: 4),
                Text(addInfoViewModel
                        .educationControllers[index]['passYearController']!
                        .text
                        .isNotEmpty
                    ? addInfoViewModel
                        .educationControllers[index]['passYearController']!.text
                    : 'Passing Year'),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () => removeEducation(index),
            style: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.red),
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Remove this Education'),
                Icon(Icons.delete, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: widget.backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Consumer<AddInfoViewmodel>(
              builder: (context, value, child) {
                if (value.educationControllers.isEmpty) {
                  return const SizedBox();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.educationControllers.length,
                  itemBuilder: (context, index) {
                    return buildEducationForm(index);
                  },
                );
              },
            ),
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemCount: educationForms.length,
            //   itemBuilder: (context, index) {
            //     return buildEducationForm(index);
            //   },
            // ),

            const SizedBox(height: 16),
            AddButton(
              title: 'Add Education',
              onTap: addEducation,
            ),
            // const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
