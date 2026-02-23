import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resume_ai/core/common/widgets/loader.dart';

import '../../../../core/common/provider/current_usermodel.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils.dart';
import '../../../auth/view/pages/welcome_page.dart';
import '../../../auth/viewmodel/auth_viewmodel.dart';
import '../../viewmodel/resume_viewmodel.dart';
import '../widgets/info_tile.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = '/settings';
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final currentUserModel = Provider.of<CurrentUserModel>(context);
    final resumeViewModel = Provider.of<ResumeViewmodel>(context);

    return Scaffold(
      backgroundColor: AppPalette.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: AppPalette.scaffoldBackgroundColor,
      ),
      body: Stack(
        children: [
          resumeViewModel.isLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: const Loader(loaderSize: 70),
                )
              : const SizedBox.shrink(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoTile(title: 'Name', value: currentUserModel.user!.name),
              InfoTile(title: 'Email', value: currentUserModel.user!.email),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'LOGOUT',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'You want to logout?',
                      style: TextStyle(fontSize: 16),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                      ),
                      onPressed: () {
                        try {
                          showDialogBox(
                            context,
                            title: 'Logout',
                            content: 'Are you sure you want to logout?',
                            onConfirm: () {
                              Navigator.of(context).pop();
                              authViewModel.signOut(context);

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  WelcomePage.routeName, (route) => false);
                            },
                          );
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Want to delete current resume?',
                      style: TextStyle(fontSize: 16),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                      ),
                      onPressed: () {
                        try {
                          showDialogBox(
                            context,
                            title: 'Delete Resume',
                            content:
                                'Are you sure you want to delete your resume?',
                            onConfirm: () {
                              Navigator.of(context).pop();
                              resumeViewModel.deleteCurrentResume(context);
                            },
                          );
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
