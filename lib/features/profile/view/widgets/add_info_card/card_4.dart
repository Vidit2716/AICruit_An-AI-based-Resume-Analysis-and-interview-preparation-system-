import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resume_ai/features/profile/view/widgets/add_button.dart';

import '../../../viewmodel/add_info_viewmodel.dart';

class Card4 extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Color backgroundColor;
  final String title;

  const Card4({
    super.key,
    required this.formKey,
    required this.backgroundColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final addInfoViewModel = Provider.of<AddInfoViewmodel>(context);
    final TextEditingController skillController = TextEditingController();

    void addSkillDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text('Add a skill'),
            content: TextField(
              controller: skillController,
              decoration: InputDecoration(
                hintText: 'eg. Flutter',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (skillController.text.trim().isEmpty) {
                    return;
                  }

                  context
                      .read<AddInfoViewmodel>()
                      .addSkill(skillController.text.trim());
                  skillController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    }

    return Form(
      key: formKey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            addInfoViewModel.skills?.isNotEmpty ?? false
                ? const SizedBox(height: 16)
                : const SizedBox.shrink(),
            Wrap(
              children: addInfoViewModel.skills?.map(
                    (skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        margin: const EdgeInsets.only(right: 8, bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              skill,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () => addInfoViewModel.removeSkill(skill),
                              child: const Icon(Icons.close, size: 20),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList() ??
                  [],
            ),
            const SizedBox(height: 16),
            AddButton(
              title: 'Add a Skill',
              onTap: addSkillDialog,
            ),
          ],
        ),
      ),
    );
  }
}
