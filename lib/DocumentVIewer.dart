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
  bool _isError = false; // Biến trạng thái để theo dõi lỗi

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
              _isError = false; // Đặt lại trạng thái lỗi
            });
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false; // Khi tải xong, ẩn loading
            });
            print('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false; // Dừng loading
              _isError = true; // Đặt trạng thái lỗi
            });
            print('Error loading page: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.driveUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        check: true,
        title: 'EHUST-DOCUMENT',
      ),
      body: Stack(
        children: [
          // Nếu có lỗi, hiển thị thông báo lỗi
          if (_isError)
            Center(
              child: Text(
                'Không thể tải tệp. Vui lòng kiểm tra đường dẫn hoặc thử lại sau.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),

          // Nếu không lỗi, hiển thị WebView
          if (!_isError)
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
