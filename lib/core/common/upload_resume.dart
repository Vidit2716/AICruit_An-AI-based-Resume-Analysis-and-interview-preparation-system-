import 'package:file_picker/file_picker.dart';

class UploadResume {
  Future<String?> uploadResume() async {
    String? resumePath;

    try {
      FilePickerResult? res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (res != null) {
        resumePath = res.files.single.path;
      }
    } catch (e) {
      print(e.toString());
    }
    return resumePath;
  }

  Future<List<String>> convertPDFToImages(String resumePath) async {
    // For now, we're returning a list with just the path
    // This can be extended to convert PDFs to images using alternative methods
    return [resumePath];
  }
}
