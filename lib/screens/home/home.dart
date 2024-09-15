//homescreen of application
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late int selectedPage;
  late final PageController _pageController;

  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);

    super.initState();
  }

  final List<IconData> icons = [
    CupertinoIcons.mic,
    CupertinoIcons.viewfinder_circle,
    CupertinoIcons.signature
  ];

  final List<String> labels = [
    "Text-To-Speech",
    "Text-Magnifier",
    "Image-Text-Selection"
  ];

  final List<Color> colors = [
    Colors.blue,
    Colors.yellow,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    const pageCount = 5;

    return Scaffold(
      backgroundColor: Colors.cyan.shade500,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      selectedPage = page;
                    });
                  },
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "CLARITY",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 45.0,
                              letterSpacing: 1.0),
                        ),
                        const Text(
                          "SWIPE TO START",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 35.0,
                              letterSpacing: 1.0),
                        ),
                      ],
                    ),
                    ...List.generate(pageCount, (index) {
                      return Center(
                        child: Text('Page $index'),
                      );
                    }),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PageViewDotIndicator(
                currentItem: selectedPage,
                count: pageCount,
                unselectedColor: Colors.black26,
                selectedColor: Colors.blue,
                duration: const Duration(milliseconds: 200),
                boxShape: BoxShape.rectangle,
                onItemClicked: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
      /*Container(
        padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 30.0),
        child: ListView(
          children: [
            const Text(
              "CLARITY", textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 45.0,
                  letterSpacing: 1.0
              ),
            ),
            const Text(
              "SWIPE TO START", textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 35.0,
                  letterSpacing: 1.0
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.fromBorderSide(
                  BorderSide(
                      color: Colors.blue.shade900,
                      width: 20.0,
                      style: BorderStyle.solid),
                ),
              ),
              height: 500.0,
              clipBehavior: Clip.hardEdge,
              child: PageView(
                controller: _pageControl,
                children: [0,1,2].map((i) => Container(
                  color: colors[i],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 50.0,
                          onPressed: () {},
                          icon: Icon(icons[i]),
                        ),
                        Text(
                          labels[i],
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ),
            )
          ],
        ),
      ),*/
    );
  }
}
