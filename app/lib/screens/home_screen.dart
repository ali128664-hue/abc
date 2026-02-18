import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/download_provider.dart';
import '../widgets/url_input_field.dart';
import '../widgets/media_preview_card.dart';
import '../utils/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _handlePaste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      setState(() {
        _urlController.text = data!.text!;
      });
      _handleDownload();
    }
  }

  void _handleDownload() {
    if (_urlController.text.isNotEmpty) {
      context.read<DownloadProvider>().fetchMedia(_urlController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'InstaPro',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Show help
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'Download Instagram Reels, Videos, & Photos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            Consumer<DownloadProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    UrlInputField(
                      controller: _urlController,
                      onPaste: _handlePaste,
                      onDownload: _handleDownload,
                      isLoading: provider.isLoading,
                    ),
                    
                    if (provider.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          provider.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      
                    if (provider.fetchedMedia != null)
                      MediaPreviewCard(
                        media: provider.fetchedMedia!,
                        onDownload: () => provider.downloadMedia(provider.fetchedMedia!),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
