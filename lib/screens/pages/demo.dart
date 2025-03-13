import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../themes/theme.dart';

class Demos extends StatefulWidget {
  const Demos({super.key});

  @override
  State<Demos> createState() => _DemosState();
}

class _DemosState extends State<Demos> {

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Support Clarity',
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Help Us Make Vision Accessible',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your support helps us continue developing tools for visual accessibility',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Contact Us'),
                  const SizedBox(height: 16),
                  _buildContactCard(
                    context,
                    icon: Icons.email,
                    title: 'Email Support',
                    subtitle: 'support@clarityapp.com',
                    onTap: () => _launchURL('mailto:support@clarityapp.com'),
                  ),
                  _buildContactCard(
                    context,
                    icon: Icons.chat_bubble,
                    title: 'Community Forum',
                    subtitle: 'Join our discussion board',
                    onTap: () => _launchURL('https://community.clarityapp.com'),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Ways to Support'),
                  const SizedBox(height: 16),
                  _buildSupportOption(
                    context,
                    icon: Icons.star,
                    title: 'Rate the App',
                    description: 'Leave a review on the app store to help others discover Clarity',
                    buttonText: 'Rate Now',
                  ),
                  _buildSupportOption(
                    context,
                    icon: Icons.share,
                    title: 'Share Clarity',
                    description: 'Spread the word about Clarity to help more people access our tools',
                    buttonText: 'Share App',
                  ),

                  const SizedBox(height: 32),
                  _buildFeedbackSection(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildContactCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSupportOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String description,
        required String buttonText,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: lighterTertiaryColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Share Your Experience',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your feedback helps us improve Clarity for everyone. Let us know about your experience with the app or suggest new features.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.feedback),
            label: const Text('Send Feedback'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}