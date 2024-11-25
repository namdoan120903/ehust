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
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          }
        ),
      )
      ..loadRequest(Uri.parse(widget.driveUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST"),
      body:WebViewWidget(controller: controller)
    );}
}
