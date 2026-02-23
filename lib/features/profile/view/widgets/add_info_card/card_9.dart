import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/add_info_viewmodel.dart';

class Card9 extends StatelessWidget {
  final Color backgroundColor;
  final String title;

  const Card9({
    super.key,
    required this.backgroundColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final addInfoViewModel = Provider.of<AddInfoViewmodel>(context);

    return Container(
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
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gender',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // male
                  GestureDetector(
                    onTap: () => addInfoViewModel.setGender('Male'),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: addInfoViewModel.gender == 'Male'
                            ? Colors.black87
                            : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          'Male',
                          style: TextStyle(
                            color: addInfoViewModel.gender == 'Male'
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // female
                  GestureDetector(
                    onTap: () => addInfoViewModel.setGender('Female'),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: addInfoViewModel.gender == 'Female'
                            ? Colors.black87
                            : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          'Female',
                          style: TextStyle(
                            color: addInfoViewModel.gender == 'Female'
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Marital Status',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // single
                  GestureDetector(
                    onTap: () => addInfoViewModel.setMaritalStatus('Single'),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: addInfoViewModel.maritalStatus == 'Single'
                            ? Colors.black87
                            : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          'Single',
                          style: TextStyle(
                            color: addInfoViewModel.maritalStatus == 'Single'
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // married
                  GestureDetector(
                    onTap: () => addInfoViewModel.setMaritalStatus('Married'),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: addInfoViewModel.maritalStatus == 'Married'
                            ? Colors.black87
                            : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          'Married',
                          style: TextStyle(
                            color: addInfoViewModel.maritalStatus == 'Married'
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
