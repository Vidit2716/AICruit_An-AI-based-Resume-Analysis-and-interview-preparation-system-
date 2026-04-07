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
    List<Map<String, String>> parseStringMapList(String key) {
      final dynamic rawList = map[key];
      if (rawList is! List) return <Map<String, String>>[];

      return rawList
          .whereType<Map>()
          .map(
            (item) => item.map(
              (k, v) => MapEntry(
                k.toString(),
                v?.toString() ?? '',
              ),
            ),
          )
          .toList();
    }

    return ResumeModel(
      firstName: (map['firstName'] ?? '').toString(),
      lastName: (map['lastName'] ?? '').toString(),
      bio: (map['bio'] ?? '').toString(),
      yearsOfExp: (map['yearsOfExp'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      phone: (map['phone'] ?? '').toString(),
      skills: map['skills'] is List
          ? (map['skills'] as List).map((item) => item.toString()).toList()
          : <String>[],
      portfolioLink: (map['portfolioLink'] ?? '').toString(),
      linkedinLink: (map['linkedinLink'] ?? '').toString(),
      githubLink: (map['githubLink'] ?? '').toString(),
      otherLink: (map['otherLink'] ?? '').toString(),
      gender: (map['gender'] ?? 'Male').toString(),
      maritalStatus: (map['maritalStatus'] ?? 'Single').toString(),
      projectsControllers: parseStringMapList('projectsControllers'),
      workExperienceControllers: parseStringMapList('workExperienceControllers'),
      educationControllers: parseStringMapList('educationControllers'),
      achievementsControllers: parseStringMapList('achievementsControllers'),
    );
  }

  String toJson() => json.encode(toMap());

  factory ResumeModel.fromJson(String source) =>
      ResumeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
