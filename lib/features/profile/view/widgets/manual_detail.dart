import 'package:flutter/material.dart';
import 'package:resume_ai/features/profile/view/pages/add_your_info_page.dart';

class ManualDetail extends StatelessWidget {
  const ManualDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Profile Details Manually',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const Text(
          'Provider details about your profile so that we can build your resume',
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.all(12),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(AddYourInfoPage.routeName);
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add Your Info',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
