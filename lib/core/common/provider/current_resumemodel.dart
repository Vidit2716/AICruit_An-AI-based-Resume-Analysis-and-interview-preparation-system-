import 'package:flutter/material.dart';
import 'package:resume_ai/features/profile/model/resume_model.dart';

class CurrentResumemodel with ChangeNotifier {
  ResumeModel _resumeModel = ResumeModel(
    firstName: '',
    lastName: '',
    bio: '',
    yearsOfExp: '',
    email: '',
    phone: '',
    skills: [],
    portfolioLink: '',
    linkedinLink: '',
    githubLink: '',
    otherLink: '',
    gender: 'Male',
    maritalStatus: 'Single',
    projectsControllers: [],
    workExperienceControllers: [],
    educationControllers: [],
    achievementsControllers: [],
  );

  ResumeModel get resumeModel => _resumeModel;

  void setResumeModel(ResumeModel resumeModel) {
    _resumeModel = resumeModel;
    notifyListeners();
  }
}
