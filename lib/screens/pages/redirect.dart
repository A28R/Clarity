import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Redirect extends StatefulWidget {
  const Redirect({super.key});

  @override
  State<Redirect> createState() => _RedirectState();
}

class _RedirectState extends State<Redirect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Redirect Page"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        color: Colors.blueGrey,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("        Something went wrong! You may be on "
                "a device that cannot access certain features such "
                "as camera. This is here to inform you of that! Click "
                "the button below to navigate back to the last screen!"),
            CupertinoButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Icon(CupertinoIcons.arrow_turn_up_left,size: 50,),
            ),
          ],
        ),
      ),
    );
  }
}
