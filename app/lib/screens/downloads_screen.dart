import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/download_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
      ),
      body: Consumer<DownloadProvider>(
        builder: (context, provider, child) {
          if (provider.history.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.download_done, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No downloads yet'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.history.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = provider.history[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: item.media.thumbnailUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    item.media.caption ?? 'Instagram Media',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(item.timestamp.toString().split('.')[0]),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
