// import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
// import 'package:device_info_plus/device_info_plus.dart';

import '../../../../core/common/provider/change_bottom_bar_page.dart';
import '../../../../core/common/provider/current_usermodel.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../auth/viewmodel/auth_viewmodel.dart';
import '../../../profile/viewmodel/resume_viewmodel.dart';
import '../../viewmodel/youtube_viewmodel.dart';
import '../widgets/home_tile.dart';
import '../widgets/youtube_tile.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getPermission();

    // Youtube video details
    final youtubeViewModel =
        Provider.of<YoutubeViewmodel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      youtubeViewModel.fetchYoutubeDetails();
    });

    final resumeViewModel =
        Provider.of<ResumeViewmodel>(context, listen: false);

    resumeViewModel.getResumeFromFirestore(context);

    if (resumeViewModel.createdResumePath == null) {
      Future.microtask(() {
        resumeViewModel.getPdfPath();
      });
    }
  }

  void getPermission() async {
    // final plugin = DeviceInfoPlugin();
    // final android = await plugin.androidInfo;

    // final storageStatus = android.version.sdkInt < 33
    //     ? await Permission.storage.request()
    //     : PermissionStatus.granted;

    // if (storageStatus == PermissionStatus.granted) {
    //   log("Granted", name: "Storage Permission Home Page");
    // }
    // if (storageStatus == PermissionStatus.denied) {
    //   log("Denied");
    // }
    // if (storageStatus == PermissionStatus.permanentlyDenied) {
    //   openAppSettings();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final currentUserModel = Provider.of<CurrentUserModel>(context);
    final currentPage = Provider.of<ChangeBottomBarPage>(context);

    return Scaffold(
      backgroundColor: AppPalette.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppPalette.scaffoldBackgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(currentUserModel
                      .user!.photoUrl.isEmpty
                  ? 'https://static.vecteezy.com/system/resources/thumbnails/036/594/092/small_2x/man-empty-avatar-photo-placeholder-for-social-networks-resumes-forums-and-dating-sites-male-and-female-no-photo-images-for-unfilled-user-profile-free-vector.jpg'
                  : currentUserModel.user!.photoUrl),
              radius: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Hey! ${currentUserModel.user!.name} 🎊',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: authViewModel.isLoading
          ? const Center(
              child: Loader(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeTile(
                    backgroundColor: Colors.blue.shade100,
                    title: 'Build Your Resume PDF For Free',
                    titleColor: Colors.blue,
                    subtitle: 'Approved by HRs and takes only 2 mins to export',
                    arrowBackgroundColor: Colors.blue.shade200,
                    onPressed: () => currentPage.updateCurrentPage(3),
                  ),
                  HomeTile(
                    backgroundColor: Colors.purple.shade100,
                    title: 'Resume review with Ava',
                    titleColor: Colors.purple,
                    subtitle: 'Receive in real time depth resume feedback',
                    arrowBackgroundColor: Colors.purple.shade200,
                    onPressed: () => currentPage.updateCurrentPage(1),
                  ),
                  HomeTile(
                    backgroundColor: Colors.red.shade100,
                    title: 'Interview with Ava',
                    titleColor: Colors.red,
                    subtitle:
                        'Practice personalized mock interviews with real-time feedback',
                    arrowBackgroundColor: Colors.red.shade200,
                    onPressed: () => currentPage.updateCurrentPage(2),
                  ),
                  const SizedBox(height: 8),
                  const YouTubeTile(),
                ],
              ),
            ),
    );
  }
}
