import 'package:flutter/material.dart';
import 'package:telescopetool/description.dart';
import 'package:telescopetool/telescopetool.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Description(),
        SizedBox(width: 100),
        TelescopeTool(),
      ],
    );
  }
}
