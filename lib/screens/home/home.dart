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
  //creating selectedPage variable and a pagecontroller for pageview
  late int selectedPage;
  late final PageController _pageController;

  //list of functions for running
  late List<Function> funcs;

  @override
  void initState() {
    //initializing selectedPage and _pageController vars
    selectedPage = 0;
    _pageController =
        PageController(initialPage: selectedPage, viewportFraction: 1);

    //setting up list of funcs
    funcs = [
      () => Navigator.pushNamed(context, '/tts'),
      () => Navigator.pushNamed(context, "/magnifier"),
      () => Navigator.pushNamed(context, "/colorfilter"),
      () => Navigator.pushNamed(context, "/aiquestions"),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const pageCount = 5;
    return Scaffold(
      backgroundColor: primaryColor,
      //stack so we can have a bottom nav bar for page views
      body: Stack(alignment: Alignment.bottomCenter, children: [
        Column(
          children: [
            Expanded(
              child: PageView(
                physics: ClampingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    selectedPage = page;
                  });
                },
                children: [
                  //Page 1, contains the swipe to start screen
                  HomePage(),

                  //generates remaining pages from a bunch of lists at the top
                  //alter the func list to navigate to a function of a page
                  ...List.generate(
                    pageCount - 1,
                    (i) => GestureDetector(
                      onTap: () {
                        funcs[i]();
                        HapticFeedback.heavyImpact();
                      },
                      child: Container(
                        color: widget.colors[i],
                        child: Column(
                          //center widgets
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Mid page icon
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                              child: Text(
                                widget.labels[i].toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 33.0, fontWeight: FontWeight.w900, color: tertiaryColor, ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Icon(widget.icons[i], size: 300, color: tertiaryColor,),
                            //text below icon
                            const SizedBox(height: 20),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                              child: Text(

                                widget.descriptions[i],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500, color: tertiaryColor),
                              ),
                            ),


                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        //adding my own bottom navigation widget
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: LiamNavBar(
              //adding a parameter which is the widget within
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: PageViewDotIndicator(
                  currentItem: selectedPage,
                  count: pageCount,
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
              //adding a second parameter, bg color
              bgcolor: darkerSecondaryColor),
        ),
      ]),
    );
  }
}
