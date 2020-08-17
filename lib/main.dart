import 'package:flutter/material.dart';
import 'package:telescopetool/body.dart';
import 'package:telescopetool/centeredview.dart';
import 'package:telescopetool/navigationbar.dart';

void main() {
  runApp(ToolApp());
}

class ToolApp extends StatefulWidget {
  @override
  _ToolAppState createState() => _ToolAppState();
}

class _ToolAppState extends State<ToolApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telescope Tool',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Lato',
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: CenteredView(
          child: Column(
            children: [
              NavigationBar(),
              SizedBox(
                height: 40,
              ),
              Body(),
            ],
          ),
        ),
      ),
    );
  }
}
