// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/event.dart';

class WebViewScreen extends StatefulWidget {
  final Item item;
  const WebViewScreen({super.key, required this.item});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController controller = WebViewController();
  bool isLoading = true;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress > 10 && isLoading) {
              setState(() {
                isLoading = false;
              });
            }
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.item.eventUrl ?? ''));

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          Visibility(
            visible: isLoading,
            child: Container(
              color: Colors
                  .white, // Change the color to match your app's background
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ),
    );
  }

  appbar() {
    // IconData iconData = Utils.getCategoryIcon(widget.category!.category ?? '');
    return AppBar(
        // Set your preferred background color
        elevation: 4, // Set elevation for a slight shadow
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ), // You can use any icon for your menu
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          widget.item.eventname ?? '',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Set text color
          ),
        ));
  }
}
