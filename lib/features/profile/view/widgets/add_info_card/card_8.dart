import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/add_info_viewmodel.dart';
import '../add_button.dart';
import '../custom_text_field.dart';

class Card8 extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String title;
  final Color backgroundColor;

  const Card8({
    super.key,
    required this.formKey,
    required this.title,
    required this.backgroundColor,
  });

  @override
  State<Card8> createState() => _Card8State();
}

class _Card8State extends State<Card8> {
  late final addInforViewModel =
      Provider.of<AddInfoViewmodel>(context, listen: false);

  void addAchievement() {
    setState(() {
      addInforViewModel.achievementsControllers.add({
        'achievementTitleController': TextEditingController(),
        'achievementDescriptionController': TextEditingController(),
      });
    });
  }

  void removeAchievement(int index) {
    setState(() {
      addInforViewModel.achievementsControllers.removeAt(index);
    });
  }

  Widget buildAchievementForm(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: addInforViewModel.achievementsControllers[index]
              ['achievementTitleController']!,
          title: 'Achievement Title',
          hintText: 'eg. Published a paper in IEEE ...',
        ),
        CustomTextField(
          controller: addInforViewModel.achievementsControllers[index]
              ['achievementDescriptionController']!,
          title: 'Description',
          hintText: 'eg. This paper was about ...',
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.none,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () => removeAchievement(index),
            style: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.red),
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Remove this Achievement'),
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
                if (value.achievementsControllers.isEmpty) {
                  return const SizedBox();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.achievementsControllers.length,
                  itemBuilder: (context, index) {
                    return buildAchievementForm(index);
                  },
                );
              },
            ),
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemCount: addInforViewModel.achievementsForms.length,
            //   itemBuilder: (context, index) {
            //     return buildAchievementForm(index);
            //   },
            // ),

            const SizedBox(height: 16),
            AddButton(
              title: 'Add a Achievement',
              onTap: addAchievement,
            ),
            // const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
