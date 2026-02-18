import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/download_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            _checkLoginStatus(url);
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse('https://www.instagram.com/accounts/login/'));
  }

  Future<void> _checkLoginStatus(String url) async {
    // If we are on the main feed, we are likely logged in
    if (url == 'https://www.instagram.com/' || url.contains('instagram.com/')) {
       final cookieManager = WebViewCookieManager();
       final cookies = await cookieManager.getCookies('https://www.instagram.com/');
       
       if (cookies.isNotEmpty) {
         // Pass cookies to provider/service
         if (mounted) {
           Provider.of<DownloadProvider>(context, listen: false).updateCookies(cookies);
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('Login Successful! Cookies saved.')),
           );
           // Delay to let user see success
           await Future.delayed(const Duration(seconds: 1));
           if (mounted) Navigator.pop(context);
         }
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to Instagram'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
