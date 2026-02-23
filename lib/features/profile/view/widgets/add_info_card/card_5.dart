import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/add_info_viewmodel.dart';
import '../add_button.dart';
import '../custom_text_field.dart';

class Card5 extends StatefulWidget {
  final Color backgroundColor;
  final String title;
  final GlobalKey<FormState> formKey;

  const Card5({
    super.key,
    required this.backgroundColor,
    required this.title,
    required this.formKey,
  });

  @override
  State<Card5> createState() => _Card5State();
}

class _Card5State extends State<Card5> {
  late final addInforViewModel =
      Provider.of<AddInfoViewmodel>(context, listen: false);

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        if (addInforViewModel.projectsForms.isEmpty) {
          if (addInforViewModel.projectsControllers.isNotEmpty) {
            addInforViewModel.projectsForms.addAll(
              List.generate(
                addInforViewModel.projectsControllers.length,
                (index) => buildProjectForm(index),
              ),
            );
          }
        }
      },
    );
  }

  void addProject() {
    setState(() {
      addInforViewModel.projectsControllers.add({
        'projectTitleController': TextEditingController(),
        'descriptionController': TextEditingController(),
      });
      addInforViewModel.projectsForms.add(buildProjectForm(0));
    });
  }

  void removeProject(int index) {
    setState(() {
      addInforViewModel.projectsControllers.removeAt(index);
      addInforViewModel.projectsForms.removeAt(index);
    });
  }

  Widget buildProjectForm(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: addInforViewModel.projectsControllers[index]
              ['projectTitleController']!,
          title: 'Project Title',
          hintText: 'eg. AICruit',
        ),
        CustomTextField(
          controller: addInforViewModel.projectsControllers[index]
              ['descriptionController']!,
          title: 'Describe your project',
          hintText: 'eg. A resume builder app which ...',
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.none,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () => removeProject(index),
            style: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.red),
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Remove this Project'),
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
                if (value.projectsForms.isEmpty) {
                  return const SizedBox();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.projectsForms.length,
                  itemBuilder: (context, index) {
                    return buildProjectForm(index);
                  },
                );
              },
            ),
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemCount: addInforViewModel.projectsForms.length,
            //   itemBuilder: (context, index) {
            //     return buildProjectForm(index);
            //   },
            // ),
            const SizedBox(height: 16),
            AddButton(
              title: 'Add Project',
              onTap: addProject,
            ),
          ],
        ),
      ),
    );
  }
}
