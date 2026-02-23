// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class AnalysedResumeModel {
  final String id;
  final String name;
  final String overallFeedback;
  final String overallScore;
  final String grammarScore;
  final String contentScore;
  final String clarityScore;
  final String readabilityScore;
  final List<String> positiveImpactSentences;
  final List<String> negativeImpactSentences;
  final List<String> jobRoles;
  final List<String> generalFeedback;
  final List<String> suggestionsForImprovement;
  final String wholeResumeContent;
  final Timestamp timestamp;

  AnalysedResumeModel({
    required this.id,
    required this.name,
    required this.overallFeedback,
    required this.overallScore,
    required this.grammarScore,
    required this.contentScore,
    required this.clarityScore,
    required this.readabilityScore,
    required this.positiveImpactSentences,
    required this.negativeImpactSentences,
    required this.jobRoles,
    required this.generalFeedback,
    required this.suggestionsForImprovement,
    required this.wholeResumeContent,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'overallFeedback': overallFeedback,
      'overallScore': overallScore,
      'grammarScore': grammarScore,
      'contentScore': contentScore,
      'clarityScore': clarityScore,
      'readabilityScore': readabilityScore,
      'positiveImpactSentences': positiveImpactSentences,
      'negativeImpactSentences': negativeImpactSentences,
      'jobRoles': jobRoles,
      'generalFeedback': generalFeedback,
      'suggestionsForImprovement': suggestionsForImprovement,
      'wholeResumeContent': wholeResumeContent,
      'timestamp': timestamp,
    };
  }

  factory AnalysedResumeModel.fromMap(Map<String, dynamic> map) {
    return AnalysedResumeModel(
      id: map['id'] as String,
      name: map['name'] as String,
      overallFeedback: map['overallFeedback'] as String,
      overallScore: map['overallScore'] as String,
      grammarScore: map['grammarScore'] as String,
      contentScore: map['contentScore'] as String,
      clarityScore: map['clarityScore'] as String,
      readabilityScore: map['readabilityScore'] as String,
      positiveImpactSentences: List<String>.from(
        (map['positiveImpactSentences'] as List<String>),
      ),
      negativeImpactSentences: List<String>.from(
        (map['negativeImpactSentences'] as List<String>),
      ),
      jobRoles: List<String>.from(
        (map['jobRoles'] as List<String>),
      ),
      generalFeedback: List<String>.from(
        (map['generalFeedback'] as List<String>),
      ),
      suggestionsForImprovement: List<String>.from(
        (map['suggestionsForImprovement'] as List<String>),
      ),
      wholeResumeContent: map['wholeResumeContent'] as String,
      timestamp: map['timestamp'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory AnalysedResumeModel.fromJson(String source) =>
      AnalysedResumeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
