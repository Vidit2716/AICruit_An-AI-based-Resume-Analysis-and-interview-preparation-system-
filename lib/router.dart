import 'package:flutter/material.dart';
import 'package:resume_ai/features/resume/view/pages/analyse_resume_page.dart';
import 'package:resume_ai/features/resume/view/pages/your_resumes_page.dart';

import './core/common/widgets/bottom_bar.dart';
import './features/auth/view/pages/welcome_page.dart';
import './features/home/view/pages/home_page.dart';
import './features/profile/view/pages/settings_page.dart';
import './features/profile/view/pages/add_your_info_page.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case HomePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) {
          return const HomePage();
        },
      );
    case WelcomePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) {
          return const WelcomePage();
        },
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) {
          return const BottomBar();
        },
      );
    case SettingsPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) {
          return const SettingsPage();
        },
      );
    case AddYourInfoPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) {
          return const AddYourInfoPage();
        },
      );
    case YourResumesPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) {
          return const YourResumesPage();
        },
      );
    case AnalyseResumePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) {
          return const AnalyseResumePage();
        },
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) {
          return const Scaffold(
            body: Center(
              child: Text('Screen does not exist'),
            ),
          );
        },
      );
  }
}
