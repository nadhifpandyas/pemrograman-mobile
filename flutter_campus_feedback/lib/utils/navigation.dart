// lib/utils/navigation.dart
import 'package:flutter/material.dart';

Future<T?> pushAnimated<T>(BuildContext context, Widget page) {
  return Navigator.of(context).push<T>(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, animation, secondaryAnimation) => page,
      transitionsBuilder: (_, animation, __, child) {
        final offsetAnim = Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOut))
            .animate(animation);
        final fadeAnim = CurvedAnimation(parent: animation, curve: Curves.easeOut);
        return SlideTransition(
          position: offsetAnim,
          child: FadeTransition(opacity: fadeAnim, child: child),
        );
      },
    ),
  );
}
