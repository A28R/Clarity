import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:clarity/themes/theme.dart';
// Add these widgets after your permissions text:

// First let's make a reusable permission status widget
Widget buildPermissionStatus({
  required String title,
  required Permission permission,
}) {
  return FutureBuilder<PermissionStatus>(
    future: permission.status,
    builder: (context, snapshot) {
      if (!snapshot.hasData) return const SizedBox();

      final status = snapshot.data!;
      final isGranted = status.isGranted;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 48),
        child: Container(
          decoration: BoxDecoration(
            color: tertiaryColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: darkerSecondaryColor,
              width: 2,
            ),
          ),
          child: ListTile(
            title: Text(
              title.toUpperCase(),
              style: TextStyle(
                color: oppositeTertiaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isGranted ? Icons.check_circle : Icons.warning,
                  color: isGranted ? Colors.green : Colors.orange,
                ),
                if (!isGranted) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      await openAppSettings();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: oppositeTertiaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text('Open Settings'),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    },
  );
}

