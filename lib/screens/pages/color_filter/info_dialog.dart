import 'package:flutter/material.dart';
import 'package:clarity/themes/theme.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> myShowDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: lighterTertiaryColor,
        title:  Text(
          'Understanding Color Vision'.toUpperCase(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D3748),
          ),
        ),
        content: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoSection(
                  'Types of Color Vision Deficiency:',
                  'Protan (Red-Weak): Difficulty distinguishing between reds and greens, with reds appearing darker.\n\n'
                      'Deutan (Green-Weak): Similar to protan, but greens appear darker instead of reds.\n\n'
                      'Tritan (Blue-Yellow): Rare condition affecting blue and yellow perception.\n\n'
                      'Achromats: Complete color blindness, seeing only in shades of gray.',
                ),
                const SizedBox(height: 16),
                _buildInfoSection(
                  'Important Note:',
                  'This test is designed for educational purposes and preliminary screening only. For an accurate diagnosis, please consult an eye care professional.',
                  isWarning: true,
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Take a Test',
                  style: TextStyle(
                    color: lighterTertiaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: lighterTertiaryColor,
                ),
              ],
            ),
            onPressed: () => _launchURL(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Learn More',
                  style: TextStyle(
                    color: lighterTertiaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: lighterTertiaryColor,
                ),
              ],
            ),
            onPressed: () => _launchURL1(),
          ),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: secondaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'Exit',
              style: TextStyle(
                color: lighterTertiaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

        ],
        actionsPadding: const EdgeInsets.all(16),
      );
    },
  );
}

Widget _buildInfoSection(String title, String content, {bool isWarning = false}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isWarning ? const Color(0xFFFFF5F5) : const Color(0xFFF7FAFC),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isWarning ? const Color(0xFFFED7D7) : const Color(0xFFE2E8F0),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isWarning ? const Color(0xFFE53E3E) : const Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            color: isWarning ? const Color(0xFF742A2A) : const Color(0xFF4A5568),
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}

_launchURL1() async {
  final Uri url = Uri.parse('https://www.aoa.org/healthy-eyes/eye-and-vision-conditions/color-vision-deficiency');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

_launchURL() async {
  final Uri url = Uri.parse("https://enchroma.com/pages/color-blindness-test");
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}