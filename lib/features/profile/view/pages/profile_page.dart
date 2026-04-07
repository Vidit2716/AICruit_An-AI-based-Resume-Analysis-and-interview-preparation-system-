import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import 'package:resume_ai/core/common/widgets/loader.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../viewmodel/resume_viewmodel.dart';
import '../widgets/manual_detail.dart';
import '../widgets/upload_resume.dart';
import './settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int page = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final resumeViewModel =
          Provider.of<ResumeViewmodel>(context, listen: false);
      resumeViewModel.getResumeFromFirestore(context);
      resumeViewModel.getPdfPath();
    });
  }

  @override
  Widget build(BuildContext context) {
    final resumeViewModel = Provider.of<ResumeViewmodel>(context);
    final createdPdfPaths = resumeViewModel.createdResumePaths
        .where((path) => path.isNotEmpty && File(path).existsSync())
        .toList();

    final List<Map<String, dynamic>> templates = [
      {'name': 'Classic', 'color': Colors.deepPurple},
      {'name': 'Modern Blue', 'color': Colors.blue},
      {'name': 'Fresh Green', 'color': Colors.green},
    ];

    return Scaffold(
      backgroundColor: AppPalette.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          '🙋‍♂️ Profile',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: AppPalette.scaffoldBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsPage.routeName);
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            page = 1;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: page == 1 ? Colors.black : Colors.white30,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'Profile',
                              style: TextStyle(
                                fontSize: 16,
                                color: page == 1 ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            page = 2;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: page == 2 ? Colors.black : Colors.white30,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'Builder',
                              style: TextStyle(
                                fontSize: 16,
                                color: page == 2 ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (page == 1)
                const SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Let\'s Create Profile',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 16),
                      UploadResume(),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: Divider(thickness: 2)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('OR'),
                          ),
                          Expanded(child: Divider(thickness: 2)),
                        ],
                      ),
                      SizedBox(height: 16),
                      ManualDetail(),
                      SizedBox(height: 16),
                    ],
                  ),
                )
              else
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resume PDFs',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      if (createdPdfPaths.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: createdPdfPaths.length,
                          itemBuilder: (context, index) {
                            final pdfPath = createdPdfPaths[index];
                            final fileName = pdfPath.split('/').last;
                            return Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fileName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => Scaffold(
                                                  appBar: AppBar(
                                                    title:
                                                        const Text('PDF View'),
                                                  ),
                                                  body: PDFView(
                                                    filePath: pdfPath,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.visibility),
                                          label: const Text('View'),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            resumeViewModel.downloadGeneratedPdf(
                                              pdfPath,
                                              context,
                                            );
                                          },
                                          icon: const Icon(Icons.download),
                                          label: const Text('Download'),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red.shade400,
                                          ),
                                          onPressed: () {
                                            resumeViewModel.removeGeneratedPdf(
                                              pdfPath,
                                              context,
                                            );
                                          },
                                          icon: const Icon(Icons.delete_outline),
                                          label: const Text('Remove'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      else
                        const Text(
                          'No PDFs uploaded yet',
                          style: TextStyle(fontSize: 16),
                        ),
                      const SizedBox(height: 16),
                      const Text(
                        'Templates',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 92,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: templates.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final template = templates[index];
                            final isSelected =
                                resumeViewModel.selectedTemplateIndex == index;
                            return GestureDetector(
                              onTap: () {
                                resumeViewModel.setSelectedTemplateIndex(index);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 150,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: (template['color'] as Color)
                                      .withOpacity(isSelected ? 0.32 : 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.grey.shade400,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      template['name'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      isSelected ? 'Selected' : 'Tap to select',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.all(12),
                        ),
                        onPressed: resumeViewModel.isLoading
                            ? null
                            : () {
                                resumeViewModel.createResumePDF(context);
                              },
                        child: resumeViewModel.isLoading
                            ? const Loader(loaderSize: 20)
                            : const Center(
                                child: Text(
                                  'Build Resume✨',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),

              // Center(
              //   child: RawImage(
              //     image: resumeViewModel.pdfPageImage?[0].imageIfAvailable,
              //     fit: BoxFit.contain,
              //   ),
              // ),

              // if (resumeViewModel.pdfPageImages != null)
              //   ListView.builder(
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     itemCount: resumeViewModel.pdfPageImages!.length,
              //     itemBuilder: (context, index) {
              //       return Column(
              //         children: [
              //           RawImage(
              //             image: resumeViewModel
              //                 .pdfPageImages?[index].imageIfAvailable,
              //           ),
              //           const Divider(),
              //         ],
              //       );
              //     },
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
