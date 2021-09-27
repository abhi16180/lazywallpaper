import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final int count;
  const IconWidget({
    Key? key,
    required this.text,
    required this.icon,
    required this.iconColor,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(text),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(count.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
