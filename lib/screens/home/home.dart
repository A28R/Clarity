import 'package:camera/camera.dart';
import 'package:clarity/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';

class Home extends StatefulWidget {
  final List<IconData> icons;
  final List<String> labels;
  final List<Color> colors;

  //UNCOMMENT FOR PHYSICAL TESTING
  // final CameraDescription camera;

  const Home({
    super.key,
    required this.icons,
    required this.labels,
    required this.colors,

    //UNCOMMENT FOR PHYSICAL TESTING
    // required this.camera,
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
          () => print("u"),
          () => Navigator.pushNamed(context, "/magnifier"),
          () {},
          () {},
          () {},
    ];
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    const pageCount = 6;
    return Scaffold(
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
                  });},

                children: [
                  //Page 1, contains the swipe to start screen
                  HomePage(),

                  //generates remaining pages from a bunch of lists at the top
                  //alter the func list to navigate to a function of a page
                  ...List.generate(
                    pageCount - 1,
                    (i) => GestureDetector(
                      onTap: () => funcs[i](),
                      child: Container(
                        color: widget.colors[i],
                        child: Column(
                          //center widgets
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Mid page icon
                            Icon(widget.icons[i]),
                            //text below icon
                            Text(
                              widget.labels[i],
                              style: const TextStyle(fontSize: 20.0),
                            ),],),),),),],),),],),

        //adding my own bottom navigation widget
        LiamNavBar(
            //adding a parameter which is the widget within
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: PageViewDotIndicator(
                currentItem: selectedPage,
                count: pageCount,
                unselectedColor: Colors.blueGrey,
                selectedColor: Colors.blue,
                duration: const Duration(milliseconds: 200),
                boxShape: BoxShape.circle,
                size: const Size(40.0, 40.0),
                unselectedSize: const Size(20.0, 20.0),
                onItemClicked: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );},),),
            //adding a second parameter, bg color
            Colors.redAccent),
      ]),);}}
