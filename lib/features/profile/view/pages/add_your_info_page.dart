import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:resume_ai/features/profile/viewmodel/resume_viewmodel.dart';

import '../../../../core/common/provider/current_resumemodel.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils.dart';
import '../../model/resume_model.dart';
import '../../viewmodel/add_info_viewmodel.dart';
import '../widgets/add_info_card/card_1.dart';
import '../widgets/add_info_card/card_2.dart';
import '../widgets/add_info_card/card_3.dart';
import '../widgets/add_info_card/card_4.dart';
import '../widgets/add_info_card/card_5.dart';
import '../widgets/add_info_card/card_6.dart';
import '../widgets/add_info_card/card_7.dart';
import '../widgets/add_info_card/card_8.dart';
import '../widgets/add_info_card/card_9.dart';
import '../widgets/topper_info_card.dart';

class AddYourInfoPage extends StatefulWidget {
  static const String routeName = '/add-your-info';
  const AddYourInfoPage({super.key});

  @override
  State<AddYourInfoPage> createState() => _AddYourInfoPageState();
}

class _AddYourInfoPageState extends State<AddYourInfoPage> {
  final GlobalKey<FormState> page1Key = GlobalKey<FormState>();
  final GlobalKey<FormState> page2Key = GlobalKey<FormState>();
  final GlobalKey<FormState> page3Key = GlobalKey<FormState>();
  final GlobalKey<FormState> page4Key = GlobalKey<FormState>();
  final GlobalKey<FormState> page5Key = GlobalKey<FormState>();
  final GlobalKey<FormState> page6Key = GlobalKey<FormState>();
  final GlobalKey<FormState> page7Key = GlobalKey<FormState>();
  final GlobalKey<FormState> page8Key = GlobalKey<FormState>();

  // TextEditingControllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController expController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController portfolioController = TextEditingController();
  final TextEditingController linkedInController = TextEditingController();
  final TextEditingController githubController = TextEditingController();
  final TextEditingController otherController = TextEditingController();
  late final PageController controller;
  @override
  void initState() {
    super.initState();
    final addInfoViewModel =
        Provider.of<AddInfoViewmodel>(context, listen: false);
    controller = PageController(initialPage: addInfoViewModel.currentPage);

    final currentResumeModel =
        Provider.of<CurrentResumemodel>(context, listen: false);

    Future.microtask(() {
      addInfoViewModel.setSkills(currentResumeModel.resumeModel.skills ?? []);
      addInfoViewModel.setGender(currentResumeModel.resumeModel.gender);
      addInfoViewModel
          .setMaritalStatus(currentResumeModel.resumeModel.maritalStatus);
    });

    final resumeModel = currentResumeModel.resumeModel;

    firstNameController.text = resumeModel.firstName;
    lastNameController.text = resumeModel.lastName;
    bioController.text = resumeModel.bio;
    expController.text = resumeModel.yearsOfExp;
    emailController.text = resumeModel.email;
    phoneController.text = resumeModel.phone;
    portfolioController.text = resumeModel.portfolioLink ?? '';
    linkedInController.text = resumeModel.linkedinLink ?? '';
    githubController.text = resumeModel.githubLink ?? '';
    otherController.text = resumeModel.otherLink ?? '';
    // educationControllers
    addInfoViewModel.setEducationControllers(context);
    // projectsControllers
    addInfoViewModel.setProjectControllers(context);
    // workExperienceControllers
    addInfoViewModel.setWorkExperienceControllers(context);
    // achievementsControllers
    addInfoViewModel.setAchievementsControllers(context);
  }

  @override
  void dispose() {
    controller.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    bioController.dispose();
    expController.dispose();
    emailController.dispose();
    phoneController.dispose();
    portfolioController.dispose();
    linkedInController.dispose();
    githubController.dispose();
    otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addInfoViewModel = Provider.of<AddInfoViewmodel>(context);
    final resumeViewModel = Provider.of<ResumeViewmodel>(context);

    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          addInfoViewModel.setCurrentPageValue(0);
        }
      },
      child: Scaffold(
        backgroundColor: AppPalette.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppPalette.scaffoldBackgroundColor,
        ),
        body: resumeViewModel.isLoading
            ? const Loader()
            : Column(
                children: [
                  const TopperInfoCard(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ExpandablePageView(
                        controller: controller,
                        onPageChanged: (value) {
                          addInfoViewModel.setCurrentPageValue(value);
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        animationCurve: Curves.easeInOut,
                        children: [
                          Card1(
                            formKey: page1Key,
                            backgroundColor: Colors.purple.shade100,
                            title: 'General Information',
                            firstNameController: firstNameController,
                            lastNameController: lastNameController,
                            bioController: bioController,
                            expController: expController,
                          ),
                          Card2(
                            formKey: page2Key,
                            backgroundColor: Colors.lightGreen.shade100,
                            title: 'Contact Information',
                            emailController: emailController,
                            phoneController: phoneController,
                          ),
                          Card3(
                            formKey: page3Key,
                            backgroundColor: Colors.pink.shade100,
                            title: 'Education',
                          ),
                          Card4(
                            formKey: page4Key,
                            backgroundColor: Colors.yellow.shade100,
                            title: 'Skills',
                          ),
                          Card5(
                            formKey: page5Key,
                            backgroundColor: Colors.purple.shade100,
                            title: 'Projects',
                          ),
                          Card6(
                            formKey: page6Key,
                            title: 'Social Links',
                            backgroundColor: Colors.yellow.shade100,
                            portfolioController: portfolioController,
                            linkedInController: linkedInController,
                            githubController: githubController,
                            otherController: otherController,
                          ),
                          Card7(
                            formKey: page7Key,
                            backgroundColor: Colors.green.shade100,
                            title: 'Work Experience',
                          ),
                          Card8(
                            formKey: page8Key,
                            backgroundColor: Colors.blue.shade100,
                            title: 'Achievements',
                          ),
                          Card9(
                            backgroundColor: Colors.purple.shade100,
                            title: 'Other Information',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        if (addInfoViewModel.currentPage >= 1)
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  padding: const WidgetStatePropertyAll(
                                      EdgeInsets.all(10)),
                                  backgroundColor: const WidgetStatePropertyAll(
                                      Colors.black12),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    controller.previousPage(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  });
                                },
                                child: const Text(
                                  'Back',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        addInfoViewModel.currentPage == 8
                            ? Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    padding: const WidgetStatePropertyAll(
                                        EdgeInsets.all(10)),
                                    backgroundColor:
                                        const WidgetStatePropertyAll(
                                            Colors.black87),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    // ignore: unused_local_variable
                                    ResumeModel resumeModel = ResumeModel(
                                      firstName:
                                          firstNameController.text.trim(),
                                      lastName: lastNameController.text.trim(),
                                      bio: bioController.text.trim(),
                                      yearsOfExp: expController.text.trim(),
                                      email: emailController.text.trim(),
                                      phone: phoneController.text.trim(),
                                      skills: addInfoViewModel.skills,
                                      portfolioLink:
                                          portfolioController.text.trim(),
                                      linkedinLink:
                                          linkedInController.text.trim(),
                                      githubLink: githubController.text.trim(),
                                      otherLink: otherController.text.trim(),
                                      gender:
                                          addInfoViewModel.gender.toString(),
                                      maritalStatus: addInfoViewModel
                                          .maritalStatus
                                          .toString(),
                                      educationControllers:
                                          addInfoViewModel.educationValues,
                                      projectsControllers:
                                          addInfoViewModel.projectValues,
                                      workExperienceControllers:
                                          addInfoViewModel.workExperienceValues,
                                      achievementsControllers:
                                          addInfoViewModel.achievementsValues,
                                    );

                                    try {
                                      showDialogBox(context,
                                          title: 'Submit',
                                          content:
                                              'Are you sure you want to submit?',
                                          onConfirm: () {
                                        // pop the dialog
                                        Navigator.of(context).pop();
                                        resumeViewModel.submitResume(
                                            resumeModel, context);
                                      });
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  },
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              )
                            : Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    padding: const WidgetStatePropertyAll(
                                        EdgeInsets.all(10)),
                                    backgroundColor:
                                        const WidgetStatePropertyAll(
                                            Colors.black87),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  onPressed: () => addInfoViewModel.nextPage(
                                    context: context,
                                    pageController: controller,
                                    formKeys: [
                                      page1Key,
                                      page2Key,
                                      page3Key,
                                      page4Key,
                                      page5Key,
                                      page6Key,
                                      page7Key,
                                      page8Key,
                                    ],
                                  ),
                                  child: const Text(
                                    'Next',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
