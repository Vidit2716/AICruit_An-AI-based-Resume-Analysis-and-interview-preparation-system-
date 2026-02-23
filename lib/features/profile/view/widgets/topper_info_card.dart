import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/add_info_viewmodel.dart';

class TopperInfoCard extends StatelessWidget {
  const TopperInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final addInfoViewModel = Provider.of<AddInfoViewmodel>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 10,
              decoration: BoxDecoration(
                color: addInfoViewModel.currentPage >= 0
                    ? Colors.black
                    : Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // 2
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 10,
              decoration: BoxDecoration(
                color: addInfoViewModel.currentPage >= 1
                    ? Colors.black
                    : Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // 3
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 10,
              decoration: BoxDecoration(
                color: addInfoViewModel.currentPage >= 2
                    ? Colors.black
                    : Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // 4
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 10,
              decoration: BoxDecoration(
                color: addInfoViewModel.currentPage >= 3
                    ? Colors.black
                    : Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // 5
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 10,
              decoration: BoxDecoration(
                color: addInfoViewModel.currentPage >= 4
                    ? Colors.black
                    : Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // 6
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 10,
              decoration: BoxDecoration(
                color: addInfoViewModel.currentPage >= 5
                    ? Colors.black
                    : Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // 7
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 10,
              decoration: BoxDecoration(
                color: addInfoViewModel.currentPage >= 6
                    ? Colors.black
                    : Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // 8
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 10,
              decoration: BoxDecoration(
                color: addInfoViewModel.currentPage >= 7
                    ? Colors.black
                    : Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // 9
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 10,
              decoration: BoxDecoration(
                color: addInfoViewModel.currentPage >= 8
                    ? Colors.black
                    : Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
