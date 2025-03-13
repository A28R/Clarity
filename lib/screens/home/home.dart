import 'package:auto_size_text/auto_size_text.dart';
import 'package:clarity/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';
import 'package:clarity/themes/theme.dart';

class Home extends StatefulWidget {
  final List<IconData> icons;
  final List<String> labels;
  final List<Color> colors;
  final List<String> descriptions;


  const Home({
    super.key,
    required this.icons,
    required this.labels,
    required this.colors,
    required this.descriptions,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late int selectedPage;
  late final PageController _pageController;
  late List<Function> funcs;


  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage, viewportFraction: 1);

    funcs = [
          () => Navigator.pushNamed(context, '/tts'),
          () => Navigator.pushNamed(context, "/magnifier"),
          () => Navigator.pushNamed(context, "/colorfilter"),
          () => Navigator.pushNamed(context, "/aiquestions"),
    ];
    super.initState();
  }

  Widget _buildFeatureCard(int index) {
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.height < 700;
    final double imageHeight = isSmallScreen ? screenSize.height * 0.25 : screenSize.height * 0.3;

    return GestureDetector(
      onTap: () {
        funcs[index]();
        HapticFeedback.heavyImpact();
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.colors[index],
          borderRadius: BorderRadius.circular(0),
        ),
        child: Center(
          child: Transform.translate(
            offset: Offset(0.0, -1.0*(screenSize.height*0.025)),
            child: Container(
              height: screenSize.height*0.64,
              margin: EdgeInsets.symmetric(horizontal: 24),
              // padding: EdgeInsets.symmetric( vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 2.0, color: Colors.white.withOpacity(0.25))

              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: AutoSizeText(
                      widget.labels[index].toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 400,
                        fontWeight: FontWeight.w800,
                        color: tertiaryColor,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      maxFontSize: 40,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Icon(
                      widget.icons[index],
                      size: 200,
                      color: tertiaryColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: AutoSizeText(
                      widget.descriptions[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w500,
                        color: tertiaryColor,
                        height: 1.4,
                      ),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: LiamNavBar(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: PageViewDotIndicator(
            currentItem: selectedPage,
            count: 5,
            unselectedColor: primaryColor,
            selectedColor: tertiaryColor,
            duration: const Duration(milliseconds: 200),
            boxShape: BoxShape.circle,
            size: const Size(40.0, 40.0),
            unselectedSize: const Size(20.0, 20.0),
            onItemClicked: (index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),
        bgcolor: darkerSecondaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Expanded(
                child: PageView(
                  physics: const ClampingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      selectedPage = page;
                    });
                  },
                  children: [
                    HomePage(),
                    ...List.generate(
                      4,
                          (index) => _buildFeatureCard(index),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildPageIndicator(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}