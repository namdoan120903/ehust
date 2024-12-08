import 'package:flutter/material.dart';
import 'package:project/screens/myAppBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoogleDriveViewer extends StatefulWidget {
  final String driveUrl;

  const GoogleDriveViewer({Key? key, required this.driveUrl}) : super(key: key);

  @override
  State<GoogleDriveViewer> createState() => _GoogleDriveViewerState();
}

class _GoogleDriveViewerState extends State<GoogleDriveViewer> {
  late WebViewController controller;
  bool _isLoading = true; // Biến trạng thái để theo dõi tiến trình tải

  @override
  void initState() {
    super.initState();

    // Tạo WebViewController và cấu hình
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print('Loading: $progress%');
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true; // Khi bắt đầu tải, hiển thị loading
            });
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false; // Khi tải xong, ẩn loading
            });
            print('Page finished loading: $url');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.driveUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(check: true, title: 'EHUST',),
      body: Stack(
        children: [
          // WebView
          WebViewWidget(controller: controller),

          // Nếu đang tải, hiển thị CircularProgressIndicator
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
