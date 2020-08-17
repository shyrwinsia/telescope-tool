import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 40,
                width: 89,
                child: Image.asset("assets/logo.png"),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'TELESCOPE TOOLS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NavBarItem('TOOL 1'),
              _NavBarItem('TOOL 2'),
              _NavBarItem('TOOL 3'),
            ],
          )
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String _title;

  _NavBarItem(this._title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: FlatButton(
        onPressed: () {},
        child: Text(
          this._title,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF00487E),
          ),
        ),
      ),
    );
  }
}
