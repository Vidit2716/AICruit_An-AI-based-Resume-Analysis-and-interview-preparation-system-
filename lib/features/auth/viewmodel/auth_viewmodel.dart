// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resume_ai/core/common/provider/change_bottom_bar_page.dart';

import '../../../core/common/provider/current_usermodel.dart';
import '../../../core/common/widgets/bottom_bar.dart';
import '../../../core/utils.dart';
import '../repositories/auth_repositories.dart';
import '../view/pages/welcome_page.dart';

class   AuthViewModel with ChangeNotifier {
  final AuthRepositories _authRepositories = AuthRepositories();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void signInWithGoogle(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final user = await _authRepositories.signInWithGoogle();
    if (user == null) {
      _isLoading = false;
      notifyListeners();
      showSnackBar(context, 'Error signing in with Google');
      return;
    }

    context.read<CurrentUserModel>().setUser(user);

    Navigator.of(context)
        .pushNamedAndRemoveUntil(BottomBar.routeName, (route) => false);

    context.read<ChangeBottomBarPage>().updateCurrentPage(0);

    _isLoading = false;
    notifyListeners();
  }

  void signOut(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    await _authRepositories.signOut();

    Navigator.of(context)
        .pushNamedAndRemoveUntil(WelcomePage.routeName, (route) => false);

    _isLoading = false;
    notifyListeners();
  }
}
