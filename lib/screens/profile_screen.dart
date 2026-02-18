import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/download_provider.dart';
import '../models/media_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Downloader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_search_rounded, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Profile Photo Downloader',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Enter an Instagram username to download their high-quality profile picture.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
               padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Enter Username (e.g. instagram)',
                  prefixIcon: const Icon(Icons.alternate_email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
             if (_isLoading)
               const CircularProgressIndicator()
             else
               ElevatedButton(
                  onPressed: _handleSearch,
                  child: const Text('Search & Download'),
                ),
          ],
        ),
      ),
    );
  }

  void _handleSearch() async {
    if (_usernameController.text.isEmpty) return;
    
    setState(() => _isLoading = true);
    final provider = Provider.of<DownloadProvider>(context, listen: false); // We might need to expose fetchProfile in provider
    // For now, let's just use the logic here or add it to provider. 
    // Best practice: Add to provider.
    
    try {
      await provider.fetchProfile(_usernameController.text);
      if (mounted && provider.fetchedMedia != null) {
        // Show preview dialog or navigate
        _showProfilePreview(context, provider.fetchedMedia!, provider);
      } else {
         if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile not found')));
      }
    } finally {
      if(mounted) setState(() => _isLoading = false);
    }
  }

  void _showProfilePreview(BuildContext context, MediaModel media, DownloadProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 500,
        child: Column(
          children: [
             CircleAvatar(
               radius: 50,
               backgroundImage: NetworkImage(media.url),
             ),
             const SizedBox(height: 16),
             Text(media.username, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
             const SizedBox(height: 24),
             Image.network(media.url, height: 200),
             const SizedBox(height: 24),
             ElevatedButton(
               onPressed: () {
                 provider.downloadMedia(media);
                 Navigator.pop(context);
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloading...')));
               },
               child: const Text('Download HD Profile Picture'),
             )
          ],
        ),
      ),
    );
  }
