// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// class InterviewModel {
//   final String message;
//   final bool isUser;

//   InterviewModel({required this.message, required this.isUser});

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'message': message,
//       'isUser': isUser,
//     };
//   }

//   factory InterviewModel.fromMap(Map<String, dynamic> map) {
//     return InterviewModel(
//       message: map['message'] as String,
//       isUser: map['isUser'] as bool,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory InterviewModel.fromJson(String source) => InterviewModel.fromMap(json.decode(source) as Map<String, dynamic>);
// }
