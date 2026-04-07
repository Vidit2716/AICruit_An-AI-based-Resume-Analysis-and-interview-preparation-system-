import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';

import '../pages/add_your_info_page.dart';
import '../../viewmodel/resume_viewmodel.dart';

class UploadResume extends StatelessWidget {
  const UploadResume({super.key});

  @override
  Widget build(BuildContext context) {
    final resumeViewModel = Provider.of<ResumeViewmodel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Resume',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const Text(
          'We\'ll auto fill the profile from your current resume',
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 12),
        if (resumeViewModel.resumePath == null)
          GestureDetector(
            onTap: () => resumeViewModel.uploadResume(),
            child: DottedBorder(
              borderType: BorderType.RRect,
              dashPattern: const [10, 2],
              radius: const Radius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.file_upload_rounded),
                    SizedBox(width: 8),
                    Text('Upload Resume PDF'),
                  ],
                ),
              ),
            ),
          )
        else
          DottedBorder(
            borderType: BorderType.RRect,
            dashPattern: const [10, 2],
            radius: const Radius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Resume uploaded successfully',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    resumeViewModel.resumePath!.split('/').last,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => resumeViewModel.removeResumePath(),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Remove'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar:
                                    AppBar(title: const Text('Uploaded Resume')),
                                body: PDFView(
                                  key: Key(resumeViewModel.resumePath!),
                                  filePath: resumeViewModel.resumePath!,
                                  enableSwipe: true,
                                  swipeHorizontal: false,
                                ),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.visibility_outlined),
                        label: const Text('Preview'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: resumeViewModel.isLoading
                          ? null
                          : () async {
                              final didAutoFill = await resumeViewModel
                                  .autoFillProfileFromUploadedResume(context);
                              if (didAutoFill && context.mounted) {
                                Navigator.of(context)
                                    .pushNamed(AddYourInfoPage.routeName);
                              }
                            },
                      icon: resumeViewModel.isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.auto_fix_high),
                      label: const Text('Auto Fill and Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
