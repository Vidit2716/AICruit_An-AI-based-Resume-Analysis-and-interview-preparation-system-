import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/home/view/pages/home_page.dart';
import '../../../features/interview/view/pages/select_topic_page.dart';
import '../../../features/profile/view/pages/profile_page.dart';
import '../../../features/resume/view/pages/resume_page.dart';
import '../provider/change_bottom_bar_page.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/bottom-bar';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomePage(),
    const ResumePage(),
    const SelectTopicPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentPage = Provider.of<ChangeBottomBarPage>(context);

    return Scaffold(
      body: pages[currentPage.currentPage],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => currentPage.updateCurrentPage(index),
        currentIndex: currentPage.currentPage,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        selectedLabelStyle: const TextStyle(color: Colors.yellow),
        iconSize: 28,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home_rounded,
              size: 24,
            ),
            label: 'Home',
            backgroundColor: Colors.grey.shade300,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.summarize_outlined,
              size: 24,
            ),
            label: 'Resume',
            backgroundColor: Colors.grey.shade300,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.record_voice_over_rounded,
              size: 24,
            ),
            label: 'Interview',
            backgroundColor: Colors.grey.shade300,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.person_2_rounded,
              size: 24,
            ),
            label: 'Profile',
            backgroundColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
