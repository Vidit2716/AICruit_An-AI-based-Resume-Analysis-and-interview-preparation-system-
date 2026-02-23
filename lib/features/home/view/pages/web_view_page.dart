import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  final String videoId;

  const WebViewPage({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController(
      onPermissionRequest: (request) {
        if (request.types.contains(WebViewPermissionResourceType.microphone)) {
          request.grant();
        }
      },
    )
      ..clearCache()
      ..clearLocalStorage()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://www.youtube.com/watch?v=$videoId'),
      );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AICruit',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
