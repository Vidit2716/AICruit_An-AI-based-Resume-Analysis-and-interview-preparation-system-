import 'package:flutter/material.dart';

import '../../../features/auth/model/user.dart';

class CurrentUserModel with ChangeNotifier {
  UserModel _user = UserModel(
    id: '',
    email: '',
    name: '',
    photoUrl: '',
  );

  UserModel? get user => _user;

  void setUser(UserModel userModel) {
    _user = userModel;
    notifyListeners();
  }
}
