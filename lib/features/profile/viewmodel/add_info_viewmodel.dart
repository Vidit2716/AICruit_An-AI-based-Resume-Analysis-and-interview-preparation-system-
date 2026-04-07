// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/common/provider/current_resumemodel.dart';

class AddInfoViewmodel with ChangeNotifier {
  int _currentPage = 0;
  List<String>? _skills;
  String _gender = 'Male';
  String _maritalStatus = 'Single';
  // Projects
  final List<Map<String, TextEditingController>> _projectsControllers = [];
  final List<Widget> _projectsForms = [];
  List<Map<String, String>> _projectValues = [];
  // Education
  final List<Map<String, TextEditingController>> _educationControllers = [];
  final List<Widget> _educationForms = [];
  List<Map<String, String>> _educationValues = [];
  // work experience
  final List<Map<String, TextEditingController>> _workExperienceControllers =
      [];
  final List<Widget> _workExperienceForms = [];
  List<Map<String, String>> _workExperienceValues = [];

  // achievements
  final List<Map<String, TextEditingController>> _achievementsControllers = [];
  final List<Widget> _achievementsForms = [];
  List<Map<String, String>> _achievementsValues = [];

  int get currentPage => _currentPage;
  List<String>? get skills => _skills;
  String? get gender => _gender;
  String? get maritalStatus => _maritalStatus;

  // Projects
  List<Map<String, TextEditingController>> get projectsControllers =>
      _projectsControllers;
  List<Widget> get projectsForms => _projectsForms;
  List<Map<String, String>> get projectValues => _projectValues;

  // Education
  List<Map<String, TextEditingController>> get educationControllers =>
      _educationControllers;
  List<Widget> get educationForms => _educationForms;
  List<Map<String, String>> get educationValues => _educationValues;

  // work experience
  List<Map<String, TextEditingController>> get workExperienceControllers =>
      _workExperienceControllers;
  List<Widget> get workExperienceForms => _workExperienceForms;
  List<Map<String, String>> get workExperienceValues => _workExperienceValues;

  // achievements
  List<Map<String, TextEditingController>> get achievementsControllers =>
      _achievementsControllers;
  List<Widget> get achievementsForms => _achievementsForms;
  List<Map<String, String>> get achievementsValues => _achievementsValues;

  /*
  *
  *
  *

  ACHEIVEMENTS

  *
  *
  * 
  */

  void setAchievementsControllers(BuildContext context) {
    // set achievements controller values got from the resume model
    List<Map<String, String>>? achievementsValues =
        context.read<CurrentResumemodel>().resumeModel.achievementsControllers;

    log(achievementsValues.toString(), name: 'achievementsValues');

    // based on the achievements values, set the achievements controllers
    if (achievementsValues != null) {
      _achievementsControllers.clear();
      _achievementsForms.clear();

      for (var achievementValue in achievementsValues) {
        _achievementsControllers.add({
          'achievementTitleController': TextEditingController()
            ..text = achievementValue['achievement'] ?? '',
          'achievementDescriptionController': TextEditingController()
            ..text = achievementValue['description'] ?? '',
        });
      }
    }
  }

  void setAchievementsValue(BuildContext context) {
    final List<Map<String, String>> newAchievementsValues =
        _achievementsControllers.map((controllerMap) {
      return {
        'achievement': controllerMap['achievementTitleController']!.text,
        'description': controllerMap['achievementDescriptionController']!.text,
      };
    }).toList()
      ..removeWhere(
        (item) =>
            item['achievement']!.trim().isEmpty &&
            item['description']!.trim().isEmpty,
      );

    _achievementsValues = newAchievementsValues;

    log(_achievementsValues.toString(), name: '_achievementsValues');
  }

  /*
  *
  *
  *

  WORK EXPERIENCE

  *
  *
  * 
  */

  void setWorkExperienceControllers(BuildContext context) {
    // set work experience controller values got from the resume model
    List<Map<String, String>>? workExperienceValues = context
        .read<CurrentResumemodel>()
        .resumeModel
        .workExperienceControllers;

    log(workExperienceValues.toString(), name: 'workExperienceValues');

    // based on the work experience values, set the work experience controllers
    if (workExperienceValues != null) {
      _workExperienceControllers.clear();
      _workExperienceForms.clear();

      for (var workExperienceValue in workExperienceValues) {
        _workExperienceControllers.add({
          'companyNameController': TextEditingController()
            ..text = workExperienceValue['companyName'] ?? '',
          'positionController': TextEditingController()
            ..text = workExperienceValue['position'] ?? '',
          'descriptionController': TextEditingController()
            ..text = workExperienceValue['description'] ?? '',
        });
      }
    }
  }

  void setWorkExperienceValue(BuildContext context) {
    final List<Map<String, String>> newWorkExperienceValues =
        _workExperienceControllers.map((controllerMap) {
      return {
        'companyName': controllerMap['companyNameController']!.text,
        'position': controllerMap['positionController']!.text,
        'description': controllerMap['descriptionController']!.text,
      };
    }).toList()
      ..removeWhere(
        (item) =>
            item['companyName']!.trim().isEmpty &&
            item['position']!.trim().isEmpty &&
            item['description']!.trim().isEmpty,
      );

    _workExperienceValues = newWorkExperienceValues;

    log(_workExperienceValues.toString(), name: '_workExperienceValues');
  }

  /*
  *
  *
  *

  PROJECTS

  *
  *
  * 
  */

  void setProjectControllers(BuildContext context) {
    // set project controller values got from the resume model
    List<Map<String, String>>? projectValues =
        context.read<CurrentResumemodel>().resumeModel.projectsControllers;

    log(projectValues.toString(), name: 'projectValues');

    // based on the project values, set the project controllers
    if (projectValues != null) {
      _projectsControllers.clear();
      _projectsForms.clear();

      for (var projectValue in projectValues) {
        _projectsControllers.add({
          'projectTitleController': TextEditingController()
            ..text = projectValue['projectTitle'] ?? '',
          'descriptionController': TextEditingController()
            ..text = projectValue['description'] ?? '',
        });
      }
    }
  }

  void setProjectValue(BuildContext context) {
    final List<Map<String, String>> newProjectValues =
        _projectsControllers.map((controllerMap) {
      return {
        'projectTitle': controllerMap['projectTitleController']!.text,
        'description': controllerMap['descriptionController']!.text,
      };
    }).toList()
      ..removeWhere(
        (item) =>
            item['projectTitle']!.trim().isEmpty &&
            item['description']!.trim().isEmpty,
      );

    _projectValues = newProjectValues;

    log(_projectValues.toString(), name: '_projectValues');
  }

  /*
  *
  *
  *

  EDUCATION

  *
  *
  * 
  */

  void setEducationControllers(BuildContext context) {
    // set education controller values got from the resume model
    List<Map<String, String>>? educationValues =
        context.read<CurrentResumemodel>().resumeModel.educationControllers;

    log(educationValues.toString(), name: 'educationValues');

    // based on the education values, set the education controllers
    if (educationValues != null) {
      _educationControllers.clear();
      _educationForms.clear();

      for (var educationValue in educationValues) {
        _educationControllers.add({
          'instituteNameController': TextEditingController()
            ..text = educationValue['instituteName'] ?? '',
          'courseNameController': TextEditingController()
            ..text = educationValue['courseName'] ?? '',
          'scoreController': TextEditingController()
            ..text = educationValue['score'] ?? '',
          'passYearController': TextEditingController()
            ..text = educationValue['passYear'] ?? '',
        });
      }
    }
  }

  void setEducationValue(BuildContext context) {
    final List<Map<String, String>> newEducationValues =
        _educationControllers.map((controllerMap) {
      return {
        'instituteName': controllerMap['instituteNameController']!.text,
        'courseName': controllerMap['courseNameController']!.text,
        'score': controllerMap['scoreController']!.text,
        'passYear': controllerMap['passYearController']!.text,
      };
    }).toList()
      ..removeWhere(
        (item) =>
            item['instituteName']!.trim().isEmpty &&
            item['courseName']!.trim().isEmpty &&
            item['score']!.trim().isEmpty &&
            item['passYear']!.trim().isEmpty,
      );

    _educationValues = newEducationValues;

    log(_educationValues.toString(), name: '_educationValues');
  }

  //
  //
  //
  //
  //

  // Dont modify the below code

  //
  //
  //
  //

  void setCurrentPageValue(int value) {
    _currentPage = value;
    notifyListeners();
  }

  void setSkills(List<String> skills) {
    _skills = skills;
    notifyListeners();
  }

  void addSkill(String skill) {
    _skills ??= [];
    _skills!.add(skill);
    notifyListeners();
  }

  void removeSkill(String skill) {
    _skills!.remove(skill);
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  void setMaritalStatus(String single) {
    _maritalStatus = single;
    notifyListeners();
  }

  void nextPage({
    required BuildContext context,
    required PageController pageController,
    required List<GlobalKey<FormState>> formKeys,
  }) {
    int currentPage = pageController.page?.round() ?? 0;
    bool isValid = false;
    log('$currentPage', name: 'AddInfoViewmodel.nextPage.currentPage');

    if (currentPage == 2) {
      isValid = formKeys[2].currentState!.validate();
      isValid ? setEducationValue(context) : null;
    } else if (currentPage == 4) {
      isValid = formKeys[4].currentState!.validate();
      isValid ? setProjectValue(context) : null;
    } else if (currentPage == 6) {
      isValid = formKeys[6].currentState!.validate();
      isValid ? setWorkExperienceValue(context) : null;
    } else if (currentPage == 7) {
      isValid = formKeys[7].currentState!.validate();
      isValid ? setAchievementsValue(context) : null;
    } else if (currentPage == 5) {
      isValid = true;
    } else if (currentPage == 8) {
      isValid = true;
    } else {
      if (formKeys[currentPage].currentState != null) {
        isValid = formKeys[currentPage].currentState!.validate();
      }
    }

    if (isValid) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }
}
