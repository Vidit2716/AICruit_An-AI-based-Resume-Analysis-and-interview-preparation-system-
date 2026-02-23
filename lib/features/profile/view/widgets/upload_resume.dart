import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';

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
              height: 380,
              padding: const EdgeInsets.all(12).copyWith(top: 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => resumeViewModel.removeResumePath(),
                        icon: const Icon(Icons.cancel_outlined),
                        color: Colors.red,
                        tooltip: 'Remove Resume',
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.download_done_rounded),
                        color: Colors.green,
                        tooltip: 'Save Resume',
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
      ],
    );
  }
}
