import 'package:clarity/themes/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {    return Scaffold(
    appBar: AppBar(
      title: const Text(
        'About Clarity',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      elevation: 0,
    ),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(

            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  HexColor("#4d95d4"),
                  HexColor("#6a60b4"),
                  HexColor("#47679f")

                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Making the world clearer,\none feature at a time',
                  style: TextStyle(
                    letterSpacing: -1,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Created by Ayaan Rege, Ambrose Cole, and Liam Mpofu',
                  style: TextStyle(
                    letterSpacing: -0.4,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureSection(
                  context,
                  icon: Icons.zoom_in,
                  title: 'Magnification',
                  description: 'Advanced electronic magnifying glass with dynamic photo analysis for superior zoom quality and customization.',
                ),
                _buildFeatureSection(
                  context,
                  icon: Icons.palette,
                  title: 'Colorblind Accessibility',
                  description: 'Transform images to accommodate different types of colorblindness, making colors vibrant and distinguishable.',
                ),
                _buildFeatureSection(
                  context,
                  icon: Icons.record_voice_over,
                  title: 'Text-to-Speech',
                  description: 'Instantly convert text from images to speech with customizable voice settings and editable text output.',
                ),
                _buildFeatureSection(
                  context,
                  icon: Icons.psychology,
                  title: 'Image Q&A',
                  description: 'AI-powered system that answers questions about images, helping users understand visual content better.',
                  isLast: true,
                ),
                const SizedBox(height: 24),
                _buildAccessibilityNote(context),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  }

  Widget _buildFeatureSection(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String description,
        bool isLast = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 28,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                if (!isLast) const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilityNote(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lighterPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
            color: darkerSecondaryColor.withOpacity(0.2)
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Accessibility First',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Clarity is designed with accessibility at its core. Our simple, high-contrast interface ensures easy navigation with minimal motor control requirements. All features are thoroughly tested to work seamlessly with screen readers and other assistive technologies.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
  }