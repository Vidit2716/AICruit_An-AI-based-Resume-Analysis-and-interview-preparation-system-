import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/loader.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../viewmodel/auth_viewmodel.dart';
import '../widgets/sign_in_button.dart';

class WelcomePage extends StatelessWidget {
  static const String routeName = '/welcome-page';
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: AppPalette.scaffoldBackgroundColor,
      body: authViewModel.isLoading
          ? const Center(
              child: Loader(),
            )
          : Stack(
              children: [
                // logo 1
                Positioned(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  top: -40,
                  left: -15,
                  child: Opacity(
                    opacity: 0.7,
                    child: Image.asset(
                      'assets/images/logo-2.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // logo 2
                Positioned(
                  height: 400,
                  width: 400,
                  bottom: -70,
                  right: -75,
                  child: Opacity(
                    opacity: 0.7,
                    child: Image.asset(
                      'assets/images/logo-1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          'AICruit',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              textAlign: TextAlign.start,
                              text: const TextSpan(
                                text: 'Simplified',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' Interview Preparation',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' \nwith',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' AICruit',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Use Powerful AI Tools to prepare for your next set of Tech/Non-Tech Interviews',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SignInButton(
                      onPressed: () => authViewModel.signInWithGoogle(context),
                      title: 'Sign in with Google',
                      color: Colors.white,
                      assetUrl: 'assets/images/google-logo.png',
                      textColor: Colors.black,
                    ),
                    SignInButton(
                      onPressed: () {},
                      title: 'Sign in with Apple',
                      color: Colors.black,
                      assetUrl: 'assets/images/apple-logo.png',
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ],
            ),
    );
  }
}
