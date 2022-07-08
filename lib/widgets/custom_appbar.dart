import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: const [
            Icon(FontAwesomeIcons.chevronLeft),
            Spacer(),
            Icon(FontAwesomeIcons.message),
            SizedBox(width: 16),
            Icon(FontAwesomeIcons.headphones),
            SizedBox(width: 16),
            Icon(FontAwesomeIcons.arrowUpRightFromSquare),
          ],
        ),
      ),
    );
  }
}
