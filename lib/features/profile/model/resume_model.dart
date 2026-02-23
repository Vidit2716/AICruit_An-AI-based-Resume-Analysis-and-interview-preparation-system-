// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ResumeModel {
  final String firstName;
  final String lastName;
  final String bio;
  final String yearsOfExp;
  final String email;
  final String phone;
  final List<String>? skills;
  final String? portfolioLink;
  final String? linkedinLink;
  final String? githubLink;
  final String? otherLink;
  final String gender;
  final String maritalStatus;
  final List<Map<String, String>>? projectsControllers;
  final List<Map<String, String>>? workExperienceControllers;
  final List<Map<String, String>>? educationControllers;
  final List<Map<String, String>>? achievementsControllers;

  ResumeModel({
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.yearsOfExp,
    required this.email,
    required this.phone,
    required this.skills,
    required this.portfolioLink,
    required this.linkedinLink,
    required this.githubLink,
    required this.otherLink,
    required this.gender,
    required this.maritalStatus,
    required this.projectsControllers,
    required this.workExperienceControllers,
    required this.educationControllers,
    required this.achievementsControllers,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'bio': bio,
      'yearsOfExp': yearsOfExp,
      'email': email,
      'phone': phone,
      'skills': skills,
      'portfolioLink': portfolioLink,
      'linkedinLink': linkedinLink,
      'githubLink': githubLink,
      'otherLink': otherLink,
      'gender': gender,
      'maritalStatus': maritalStatus,
      'projectsControllers': projectsControllers,
      'workExperienceControllers': workExperienceControllers,
      'educationControllers': educationControllers,
      'achievementsControllers': achievementsControllers,
    };
  }

  factory ResumeModel.fromMap(Map<String, dynamic> map) {
    return ResumeModel(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      bio: map['bio'] as String,
      yearsOfExp: map['yearsOfExp'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      skills: map['skills'] != null
          ? List<String>.from(
              (map['skills'] as List<dynamic>).map((item) => item as String))
          : null,
      portfolioLink:
          map['portfolioLink'] != null ? map['portfolioLink'] as String : null,
      linkedinLink:
          map['linkedinLink'] != null ? map['linkedinLink'] as String : null,
      githubLink:
          map['githubLink'] != null ? map['githubLink'] as String : null,
      otherLink: map['otherLink'] != null ? map['otherLink'] as String : null,
      gender: map['gender'] as String,
      maritalStatus: map['maritalStatus'] as String,
      projectsControllers: map['projectsControllers'] != null
          ? List<Map<String, String>>.from(
              (map['projectsControllers'] as List<dynamic>)
                  .map((item) => Map<String, String>.from(item as Map)))
          : null,
      workExperienceControllers: map['workExperienceControllers'] != null
          ? List<Map<String, String>>.from(
              (map['workExperienceControllers'] as List<dynamic>)
                  .map((item) => Map<String, String>.from(item as Map)))
          : null,
      educationControllers: map['educationControllers'] != null
          ? List<Map<String, String>>.from(
              (map['educationControllers'] as List<dynamic>)
                  .map((item) => Map<String, String>.from(item as Map)))
          : null,
      achievementsControllers: map['achievementsControllers'] != null
          ? List<Map<String, String>>.from(
              (map['achievementsControllers'] as List<dynamic>)
                  .map((item) => Map<String, String>.from(item as Map)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResumeModel.fromJson(String source) =>
      ResumeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
