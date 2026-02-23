import '../model/youtube_model.dart';

class YoutubeRepositories {
  final List<YoutubeModel> _curatedVideos = [
    YoutubeModel(
      videoId: 'ELFORM9fmss',
      title: 'How to Introduce Yourself in an Interview',
      thumbnail: 'https://img.youtube.com/vi/ELFORM9fmss/sddefault.jpg',
    ),
    YoutubeModel(
      videoId: 'Hncp0mPfUvk',
      title: 'Top HR Interview Questions and Answers',
      thumbnail: 'https://img.youtube.com/vi/Hncp0mPfUvk/sddefault.jpg',
    ),
    YoutubeModel(
      videoId: 'SDk_GldOtK8',
      title: 'Tell Me About Yourself Best Sample Answer',
      thumbnail: 'https://img.youtube.com/vi/SDk_GldOtK8/sddefault.jpg',
    ),
    YoutubeModel(
      videoId: 'nET1jqI_Ntk',
      title: 'Common Interview Mistakes to Avoid',
      thumbnail: 'https://img.youtube.com/vi/nET1jqI_Ntk/sddefault.jpg',
    ),
    YoutubeModel(
      videoId: '7fXnt5l0LL8',
      title: 'Behavioral Interview Tips That Work',
      thumbnail: 'https://img.youtube.com/vi/7fXnt5l0LL8/sddefault.jpg',
    ),
    YoutubeModel(
      videoId: 'jmM1BRu4hSw',
      title: 'Technical Interview Preparation Strategy',
      thumbnail: 'https://img.youtube.com/vi/jmM1BRu4hSw/sddefault.jpg',
    ),
  ];

  Future<List<YoutubeModel>> fetchYoutubeDetails() async {
    return List<YoutubeModel>.from(_curatedVideos);
  }
}
