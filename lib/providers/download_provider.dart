import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:uuid/uuid.dart';
import '../models/media_model.dart';
import '../services/download_service.dart';

class DownloadProvider extends ChangeNotifier {
  final DownloadService _downloadService = DownloadService();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  MediaModel? _fetchedMedia;
  MediaModel? get fetchedMedia => _fetchedMedia;

  List<DownloadItem> _history = [];
  List<DownloadItem> get history => _history;

  String? _error;
  String? get error => _error;

  List<dynamic> _cookies = []; // Store cookies

  void updateCookies(List<dynamic> cookies) {
    _cookies = cookies;
    notifyListeners();
  }

  Future<void> fetchMedia(String url) async {
    _isLoading = true;
    _error = null;
    _fetchedMedia = null;
    notifyListeners();

    try {
      _fetchedMedia = await _downloadService.fetchMedia(url, cookies: _cookies);
      if (_fetchedMedia == null) {
        _error = "Could not fetch media. Account might be private or login required.";
      }
    } catch (e) {
      _error = "Failed to fetch media: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProfile(String username) async {
    _isLoading = true;
    _error = null;
    _fetchedMedia = null;
    notifyListeners();

    try {
      _fetchedMedia = await _downloadService.fetchProfile(username, cookies: _cookies);
      if (_fetchedMedia == null) {
        _error = "Could not fetch profile.";
      }
    } catch (e) {
      _error = "Failed to fetch profile: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> downloadMedia(MediaModel media) async {
    // Request permissions
    /*
      Note: On Android 13+, explicit storage permission might not be needed for simple gallery saving 
      if using specific APIs, but it's good practice to check logic.
      We'll use a simple check for now.
    */
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        _error = "Permission denied";
        notifyListeners();
        return;
      }
    }

    try {
      final success = await GallerySaver.saveVideo(media.url) ?? false;
       // Note: logic differs for image/video. Simplified here.
       if (media.type == MediaType.video) {
         await GallerySaver.saveVideo(media.url);
       } else {
         await GallerySaver.saveImage(media.url);
       }
       
       // Add to history
       _addToHistory(media);
       
    } catch (e) {
      _error = "Download failed: $e";
      notifyListeners();
    }
  }

  void _addToHistory(MediaModel media) {
    _history.insert(0, DownloadItem(
      id: const Uuid().v4(),
      filePath: '', // Path handling in gallery saver is opaque, simplified
      media: media,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

class DownloadItem {
  final String id;
  final String filePath;
  final MediaModel media;
  final DateTime timestamp;

  DownloadItem({
    required this.id,
    required this.filePath, 
    required this.media,
    required this.timestamp,
  });
}
