import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class UrlInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPaste;
  final VoidCallback onDownload;
  final bool isLoading;

  const UrlInputField({
    super.key,
    required this.controller,
    required this.onPaste,
    required this.onDownload,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Paste Instagram Link...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
            ),
          ),
          if (controller.text.isEmpty)
            IconButton(
              icon: const Icon(Icons.paste_rounded, color: AppTheme.primaryColor),
              onPressed: onPaste,
            )
          else
            IconButton(
              icon: const Icon(Icons.clear_rounded, color: Colors.grey),
              onPressed: () => controller.clear(),
            ),
          const SizedBox(width: 8),
          
          ElevatedButton(
            onPressed: isLoading ? null : onDownload,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.arrow_downward_rounded),
          ),
        ],
      ),
    );
  }
}
