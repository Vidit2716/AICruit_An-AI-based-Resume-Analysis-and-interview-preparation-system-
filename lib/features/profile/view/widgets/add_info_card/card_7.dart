import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/add_info_viewmodel.dart';
import '../add_button.dart';
import '../custom_text_field.dart';

class Card7 extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Color backgroundColor;
  final String title;

  const Card7({
    super.key,
    required this.formKey,
    required this.backgroundColor,
    required this.title,
  });

  @override
  State<Card7> createState() => _Card7State();
}

class _Card7State extends State<Card7> {
  late final addInfoViewModel =
      Provider.of<AddInfoViewmodel>(context, listen: false);

  void addWorkExperience() {
    setState(() {
      addInfoViewModel.workExperienceControllers.add({
        'companyNameController': TextEditingController(),
        'positionController': TextEditingController(),
        'descriptionController': TextEditingController(),
      });
    });
  }

  void removeWorkExperience(int index) {
    setState(() {
      addInfoViewModel.workExperienceControllers.removeAt(index);
    });
  }

  Widget buildWorkExperienceFrom(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Work Experience ${index + 1}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: addInfoViewModel.workExperienceControllers[index]
              ['companyNameController']!,
          title: 'Company Name',
          hintText: 'eg. Google',
        ),
        CustomTextField(
          controller: addInfoViewModel.workExperienceControllers[index]
              ['positionController']!,
          title: 'Position',
          hintText: 'eg. Software Engineer',
        ),
        CustomTextField(
          controller: addInfoViewModel.workExperienceControllers[index]
              ['descriptionController']!,
          title: 'Description',
          hintText: 'eg. Worked on Flutter project',
          maxLines: 5,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () => removeWorkExperience(index),
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
                if (value.workExperienceControllers.isEmpty) {
                  return const SizedBox();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.workExperienceControllers.length,
                  itemBuilder: (context, index) {
                    return buildWorkExperienceFrom(index);
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            AddButton(
              title: 'Add Work Experience',
              onTap: addWorkExperience,
            ),
          ],
        ),
      ),
    );
  }
}
