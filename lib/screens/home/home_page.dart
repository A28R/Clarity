// import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:clarity/themes/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildNavigationButton({
    required BuildContext context,
    required IconData icon,
    required String route,
  }) {
    // Existing navigation button code remains the same
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, route);
          HapticFeedback.mediumImpact();
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: lighterTertiaryColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: darkerSecondaryColor.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: lighterPrimaryColor.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 42,
                  color: darkerSecondaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.height < 880;
    final double imageHeight = isSmallScreen ? screenSize.height * 0.33 : screenSize.height * 0.38;
    print(screenSize.height.toString()+ "    "+screenSize.width.toString() );
    return Scaffold(
      backgroundColor: lighterTertiaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: screenSize.height * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: isSmallScreen ? 40 : 60),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: darkerSecondaryColor.withOpacity(0.0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: darkerSecondaryColor.withOpacity(0.1),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(
                    child: AutoSizeText(
                      maxLines: 1,
                      "CLARITY",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 200,
                        letterSpacing: -2.0,
                        color: darkerSecondaryColor,
                      ),
                    ),
                    height: screenSize.height*0.12,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.1),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.hand_draw,
                          size: 20,
                          color: darkerSecondaryColor.withOpacity(0.8),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Swipe To Start".toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: isSmallScreen ? 20.0 : 24.0,
                            color: darkerSecondaryColor.withOpacity(0.8),
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            // Rest of the existing code remains the same
            Center(
              child: Image.asset(
                'assets/clarity_icon_wotext.jpeg',
                height: imageHeight,
                fit: BoxFit.contain,

              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 24,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lighterPrimaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: darkerSecondaryColor.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  _buildNavigationButton(
                    context: context,
                    icon: CupertinoIcons.settings,
                    route: "/settings",
                  ),

                  const SizedBox(width: 12),
                  _buildNavigationButton(
                    context: context,
                    icon: CupertinoIcons.info_circle,
                    route: "/info",
                  ),
                  const SizedBox(width: 12),
                  _buildNavigationButton(
                    context: context,
                    icon: Icons.people_rounded,
                    route: "/demos",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}