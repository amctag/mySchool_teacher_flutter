import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 120});

  static const assetPath = 'images/icon.png';

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipOval(
        child: ColoredBox(
          color: Colors.white,
          child: SizedBox(
            width: size,
            height: size,
            child: Padding(
              padding: EdgeInsets.all(size * 0.12),
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
                semanticLabel: 'MS teacher',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
