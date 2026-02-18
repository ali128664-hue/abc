import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/media_model.dart';

class MediaPreviewCard extends StatelessWidget {
  final MediaModel media;
  final VoidCallback onDownload;

  const MediaPreviewCard({
    super.key,
    required this.media,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              media.username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(media.type.name.toUpperCase()),
          ),
          
          // Media Preview
          ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: media.thumbnailUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 300,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 300,
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                ),
                if (media.type == MediaType.video)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
              ],
            ),
          ),
          
          if (media.caption != null)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                media.caption!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onDownload,
                icon: const Icon(Icons.save_alt_rounded),
                label: const Text('Download to Gallery'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
