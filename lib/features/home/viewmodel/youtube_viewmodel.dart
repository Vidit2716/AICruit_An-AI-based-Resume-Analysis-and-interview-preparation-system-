import 'package:flutter/material.dart';

import '../model/youtube_model.dart';
import '../repositories/youtube_repositories.dart';

class YoutubeViewmodel with ChangeNotifier {
  final YoutubeRepositories _youtubeRepositories = YoutubeRepositories();
  List<YoutubeModel>? _videoDetails = [];
  bool _isFetching = false;

  List<YoutubeModel>? get videoDetails => _videoDetails;

  Future<void> fetchYoutubeDetails() async {
    if (_isFetching || _videoDetails!.isNotEmpty) return;
    _isFetching = true;

    try {
      _videoDetails = await _youtubeRepositories.fetchYoutubeDetails();
      notifyListeners();
    } catch (e) {
      print(e.toString());
    } finally {
      _isFetching = false;
    }
  }
}
