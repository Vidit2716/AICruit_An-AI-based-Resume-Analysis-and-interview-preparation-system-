import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../viewmodel/youtube_viewmodel.dart';
import '../pages/web_view_page.dart';
import './youtube_card.dart';

class YouTubeTile extends StatelessWidget {
  const YouTubeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            'Get Ready',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text('Crack your Interviews like a pro!'),
        ),
        const SizedBox(height: 8),
        Consumer<YoutubeViewmodel>(
          builder: (context, youtubViewModel, child) {
            return youtubViewModel.videoDetails!.isEmpty
                ? SizedBox(
                    height: 205,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        5,
                        (index) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: YoutubeCard(
                            thumbnail:
                                'https://static.vecteezy.com/system/resources/thumbnails/036/594/092/small_2x/man-empty-avatar-photo-placeholder-for-social-networks-resumes-forums-and-dating-sites-male-and-female-no-photo-images-for-unfilled-user-profile-free-vector.jpg',
                            title: 'Loading...',
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 205,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: youtubViewModel.videoDetails!
                          .map(
                            (e) => YoutubeCard(
                              thumbnail: e.thumbnail,
                              title: e.title,
                              onPressed: () {
                                print(e.videoId);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WebViewPage(videoId: e.videoId),
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  );
          },
        ),
      ],
    );
  }
}
