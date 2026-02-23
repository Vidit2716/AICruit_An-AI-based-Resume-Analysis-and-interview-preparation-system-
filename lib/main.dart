import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resume_ai/firebase_options.dart';

import './router.dart';
import './core/common/widgets/bottom_bar.dart';
import './core/common/widgets/loader.dart';
import './core/common/provider/current_usermodel.dart';
import './core/common/provider/current_resumemodel.dart';
import './core/common/provider/change_bottom_bar_page.dart';
import './core/common/secret.dart';
import './core/theme/app_pallete.dart';
import './features/auth/view/pages/welcome_page.dart';
import './features/auth/viewmodel/auth_viewmodel.dart';
import './features/auth/model/user.dart';
import './features/home/viewmodel/youtube_viewmodel.dart';
import './features/profile/viewmodel/resume_viewmodel.dart';
import './features/profile/viewmodel/add_info_viewmodel.dart';
import './features/resume/viewmodel/resume_viewmodel.dart' as resume;
import './features/interview/viewmodel/interview_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Gemini with API key
  Gemini.init(apiKey: geminiApiKey);
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.openBox('pdfPathsBox');

  // var box = Hive.box('pdfPathsBox');
  // await box.put('resume_pdf_path', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => CurrentUserModel()),
        ChangeNotifierProvider(create: (context) => YoutubeViewmodel()),
        ChangeNotifierProvider(create: (context) => ResumeViewmodel()),
        ChangeNotifierProvider(create: (context) => AddInfoViewmodel()),
        ChangeNotifierProvider(create: (context) => CurrentResumemodel()),
        ChangeNotifierProvider(create: (context) => ChangeBottomBarPage()),
        ChangeNotifierProvider(create: (context) => resume.ResumeViewmodel()),
        ChangeNotifierProvider(create: (context) => InterviewViewModel()),
      ],
      child: MaterialApp(
        title: 'AICruit',
        theme: ThemeData(
          scaffoldBackgroundColor: AppPalette.scaffoldBackgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppPalette.scaffoldBackgroundColor,
            elevation: 0,
          ),
        ),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              Future.microtask(() {
                context.read<CurrentUserModel>().setUser(
                      UserModel(
                        id: snapshot.data!.uid,
                        email: snapshot.data!.email!,
                        name: snapshot.data!.displayName!,
                        photoUrl: snapshot.data!.photoURL!,
                      ),
                    );
              });
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Loader(),
              );
            }
            if (snapshot.hasData) {
              return const BottomBar();
            }

            return const WelcomePage();
          },
        ),
      ),
    );
  }
}
  
