import 'package:flutter/material.dart';
import 'package:clarity/themes/theme.dart';
import 'package:app_settings/app_settings.dart';

class PermissionScreen extends StatelessWidget {
  final Function checkCameraPermission;
  final BuildContext context;

  PermissionScreen({super.key, required this.checkCameraPermission, required this.context});

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: tertiaryColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: oppositeTertiaryColor, width: 2),
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              "Your Camera is Disabled. Open Settings to fix this.",
              style: TextStyle(
                fontSize: 26,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => AppSettings.openAppSettings(),
            style: ElevatedButton.styleFrom(
              backgroundColor: tertiaryColor,
              foregroundColor: oppositeTertiaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.black, width: 2),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Open Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => checkCameraPermission(),
            style: ElevatedButton.styleFrom(
              backgroundColor: tertiaryColor,
              foregroundColor: oppositeTertiaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.black, width: 2),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Reload',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
