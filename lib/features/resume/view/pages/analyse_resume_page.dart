import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import 'package:resume_ai/core/common/widgets/loader.dart';
import 'package:resume_ai/core/utils.dart';

import '../../viewmodel/resume_viewmodel.dart';
import '../widgets/custom_button.dart';

class AnalyseResumePage extends StatelessWidget {
  static const String routeName = '/analyse-resume';
  const AnalyseResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    final resumeViewModel = Provider.of<ResumeViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Analysis'),
      ),
      body: resumeViewModel.isLoading
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Loader(),
                SizedBox(height: 8),
                Text('Analyzing Resume...'),
                SizedBox(height: 8),
                Text('Do not close the app or go back'),
                Text(
                    'This may take a while depending on the size of the resume'),
              ],
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upload Resume',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'PDF Format only (Max File Size 10 MB)',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (resumeViewModel.resumePath == null)
                    Expanded(
                      child: DottedBorder(
                        dashPattern: const [10, 2],
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(16),
                        child: GestureDetector(
                          onTap: () => resumeViewModel.uploadResume(),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color.fromARGB(255, 197, 194, 194),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cloud_upload_outlined, size: 50),
                                  Text('Click to Upload Resume'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        dashPattern: const [10, 2],
                        radius: const Radius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12).copyWith(top: 0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        resumeViewModel.removeResumePath(),
                                    icon: const Icon(Icons.cancel_outlined),
                                    color: Colors.red,
                                    tooltip: 'Remove Resume',
                                  ),
                                ],
                              ),
                              Expanded(
                                child: PDFView(
                                  key: Key(resumeViewModel.resumePath!),
                                  filePath: resumeViewModel.resumePath!,
                                  enableSwipe: true,
                                  swipeHorizontal: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  resumeViewModel.resumePath != null
                      ? CustomButton(
                          title: 'Analyse Resume',
                          onTap: () => resumeViewModel.analyseResume(
                            resumeViewModel.resumePath!,
                            resumeViewModel.pdfPageImages!,
                            context,
                          ),
                        )
                      : CustomButton(
                          title: 'Analyse Resume',
                          onTap: () {
                            showSnackBar(
                              context,
                              'Please upload a resume',
                              duration: 1,
                            );
                          }),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}
