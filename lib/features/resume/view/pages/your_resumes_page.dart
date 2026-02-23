import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resume_ai/core/common/widgets/loader.dart';
import 'package:resume_ai/features/resume/model/analysed_resume_model.dart';
import 'package:resume_ai/features/resume/view/widgets/analysed_resume_tile.dart';

class YourResumesPage extends StatelessWidget {
  static const String routeName = '/your-resumes';
  const YourResumesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Resumes'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Text(
                'Analysed resumes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (user == null)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child: Text(
                    'Please sign in to view analysed resumes.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            else
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('analysedResumes')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Could not load analysed resumes.\n${snapshot.error}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                } else if (snapshot.data?.docs.isEmpty ?? true) {
                  return const Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: Text(
                        'No analysed resumes found!',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }

                final data = snapshot.data?.docs ?? [];

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final doc = data[index];
                    final map = doc.data();

                    AnalysedResumeModel analysedResume = AnalysedResumeModel(
                      id: map['id'] ?? '',
                      name: map['name'] ?? '',
                      overallFeedback: map['overallFeedback'] ?? '',
                      overallScore: map['overallScore'] ?? '0',
                      grammarScore: map['grammarScore'] ?? '0',
                      contentScore: map['contentScore'] ?? '0',
                      clarityScore: map['clarityScore'] ?? '0',
                      readabilityScore: map['readabilityScore'] ?? '0',
                      positiveImpactSentences:
                          List<String>.from(map['positiveImpactSentences'] ?? []),
                      negativeImpactSentences:
                          List<String>.from(map['negativeImpactSentences'] ?? []),
                      jobRoles: List<String>.from(map['jobRoles'] ?? []),
                      generalFeedback:
                          List<String>.from(map['generalFeedback'] ?? []),
                      suggestionsForImprovement:
                          List<String>.from(map['suggestionsForImprovement'] ?? []),
                      wholeResumeContent: map['wholeResumeContent'] ?? '',
                      timestamp: map['timestamp'] ?? Timestamp.now(),
                    );

                    return AnalysedResumeTile(analysedResume: analysedResume);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
