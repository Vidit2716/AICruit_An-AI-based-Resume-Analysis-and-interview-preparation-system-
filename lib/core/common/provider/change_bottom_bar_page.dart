import 'package:flutter/material.dart';

class ChangeBottomBarPage extends ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void updateCurrentPage(int index) {
    _currentPage = index;
    notifyListeners();
  }
}
