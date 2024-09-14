//homescreen of application

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final PageController _pageControl = PageController();
  int currentIndex = 0;

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
    return Scaffold(
      backgroundColor: Colors.cyan.shade500,
      body: Container(
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
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() {
          _pageControl.jumpToPage(i);
          currentIndex = _pageControl.page!.round();
        }
        ),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.speaker),
            title: Text("TTS"),
            selectedColor: Colors.purple,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.search),
            title: Text("TM"),
            selectedColor: Colors.pink,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(Icons.text_fields_rounded),
            title: Text("ITS"),
            selectedColor: Colors.orange.shade900,
          ),
        ],
      ),
    );
  }
}
