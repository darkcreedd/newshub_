import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newshub_tabview/services/check_internet_connectivity.dart';
import 'package:provider/provider.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class WebViewScreen extends StatefulWidget {
  WebViewScreen({super.key, required this.newsUrl});
  String newsUrl;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  String finalUrl = 'https://flutter.dev/';
  WebViewController controller = WebViewController();
  bool isLoaded = false;
  double xprogress = 0;
  String state = '';
  CheckInternet? _checkInternet;

  // ignore: prefer_typing_uninitialized_variables
  var valueNotifier;

  @override
  void initState() {
    super.initState();
    _checkInternet?.checkRealtimeConnection();
    _checkInternet = Provider.of<CheckInternet>(context, listen: false);

    finalUrl = widget.newsUrl;
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            // Update loading bar.
            setState(() {
              xprogress = (progress - 10).toDouble();
              valueNotifier = ValueNotifier(xprogress);
              if (valueNotifier == 100) {
                state = 'Setting up page...';
              }
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              isLoaded = true;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.newsUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 231, 20, 5),
        title: Text(
          'News Hub',
          style: TextStyle(fontSize: 22.sp),
        ),
      ),
      body: (_checkInternet!.status != 'Offline')
          ? Visibility(
              visible: isLoaded,
              replacement: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SimpleCircularProgressBar(
                      progressStrokeWidth: 8.w,
                      mergeMode: true,
                      progressColors: const [
                        Color.fromARGB(255, 231, 20, 5),
                      ],
                      valueNotifier: valueNotifier,
                      onGetText: (value) {
                        if (value.toInt() == 100) {
                          state = 'Setting up page...';
                        }
                        return Text('${value.toInt()}%');
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state,
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              child: WebViewWidget(controller: controller),
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No Internet",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Text(
                    "Check your internet connection and go back to to previous page",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(45.w, 300.w),
                        backgroundColor: const Color.fromARGB(255, 231, 20, 5),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Back to Previous page',
                        style: TextStyle(fontSize: 14.sp),
                      ))
                ],
              ),
            ),
    );
  }
}
