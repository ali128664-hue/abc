import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:html/parser.dart' as parser;
import '../models/media_model.dart';
import '../utils/constants.dart';

class DownloadService {
  final Dio _dio = Dio();
  final CookieJar _cookieJar = CookieJar();

  DownloadService() {
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  Future<MediaModel?> fetchMedia(String url, {List<dynamic>? cookies}) async {
    try {
      // Basic validation
      if (!url.contains('instagram.com')) {
        throw Exception('Invalid Instagram URL');
      }

      if (cookies != null && cookies.isNotEmpty) {
        // Convert webview cookies to Dio cookies if needed, or just set headers
        // For simplicity, we'll try setting the 'Cookie' header directly if format matches
        // or iterate and save to cookieJar.
        // Assuming cookies is List<WebViewCookie>
        // Actual implementation depends on the object type from webview_flutter
        // We'll manually construct a cookie string for the header for now as a robust fallback
        String cookieHeader = cookies.map((c) => '${c.name}=${c.value}').join('; ');
        
        _dio.options.headers['Cookie'] = cookieHeader;
      }

      // 1. Try to fetch the page content
      // Note: In a real production app, you might need to handle user agents, proxies, or cookies extensively.
      // This is a simplified scraping approach.
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
          }
        ),
      );

      if (response.statusCode == 200) {
        final document = parser.parse(response.data);
        
        // Strategy 1: Look for Open Graph tags (og:video, og:image)
        // This is the most reliable public method without API
        final ogVideo = document.querySelector('meta[property="og:video"]')?.attributes['content'];
        final ogImage = document.querySelector('meta[property="og:image"]')?.attributes['content'];
        final ogTitle = document.querySelector('meta[property="og:title"]')?.attributes['content']; // Usually contains caption/username
        
        if (ogVideo != null) {
           return MediaModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(), // Temp ID
            url: ogVideo,
            thumbnailUrl: ogImage ?? '',
            type: MediaType.video,
            username: _extractUsername(ogTitle) ?? 'Instagram User',
            caption: ogTitle,
            isPrivate: false,
          );
        } else if (ogImage != null) {
           // Check if it's a profile pic or post
           return MediaModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            url: ogImage,
            thumbnailUrl: ogImage,
            type: MediaType.image,
            username: _extractUsername(ogTitle) ?? 'Instagram User',
            caption: ogTitle,
             isPrivate: false,
          );
        }
      }
      
      return null;
    } catch (e) {
      print('Error fetching media: $e'); 
      // In a real app, rethrow or return custom error
      rethrow;
    }
  }

  Future<MediaModel?> fetchProfile(String username, {List<dynamic>? cookies}) async {
    try {
      final url = 'https://www.instagram.com/$username/';
       if (cookies != null && cookies.isNotEmpty) {
        String cookieHeader = cookies.map((c) => '${c.name}=${c.value}').join('; ');
        _dio.options.headers['Cookie'] = cookieHeader;
      }

      final response = await _dio.get(url, options: Options(headers: {
         'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
      }));

      if (response.statusCode == 200) {
        final document = parser.parse(response.data);
        final ogImage = document.querySelector('meta[property="og:image"]')?.attributes['content'];
        final ogTitle = document.querySelector('meta[property="og:title"]')?.attributes['content'];

        if (ogImage != null) {
          return MediaModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            url: ogImage, // This is usually the HD profile pic in og:image
            thumbnailUrl: ogImage,
            type: MediaType.image,
            username: username,
            caption: ogTitle, // Bio or name
            isPrivate: false,
          );
        }
      }
      return null;
    } catch (e) {
      print('Error fetching profile: $e');
      rethrow;
    }
  }

  String? _extractUsername(String? title) {
    if (title == null) return null;
    // Format usually: "Username on Instagram: Caption"
    if (title.contains(' on Instagram:')) {
      return title.split(' on Instagram:')[0].trim();
    }
    return null;
  }
}
