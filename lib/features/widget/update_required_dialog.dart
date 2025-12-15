import 'package:flutter/material.dart';
import 'package:tabumium/features/utility/const/constant_string.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateRequiredDialog extends StatelessWidget {
  final String message;
  final String storeUrl;

  const UpdateRequiredDialog({
    super.key,
    required this.message,
    required this.storeUrl,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent dismissing dialog
      child: AlertDialog(
        title: Text(
          ConstantString.updateRequiredTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final uri = Uri.parse(storeUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: Text(ConstantString.update),
          ),
        ],
      ),
    );
  }
}
