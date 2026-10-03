import 'dart:math' as math;

import 'package:flutter/material.dart';

class TasteContentFrame extends StatelessWidget {
  const TasteContentFrame({
    super.key,
    required this.child,
    this.maxWidth = 980,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: math.min(constraints.maxWidth, maxWidth),
            height: constraints.maxHeight,
            child: child,
          ),
        );
      },
    );
  }
}
