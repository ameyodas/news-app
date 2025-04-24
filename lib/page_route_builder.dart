import 'package:flutter/widgets.dart';

class INPageRouteBuilder extends PageRouteBuilder {
  INPageRouteBuilder({required super.pageBuilder})
      : super(
          transitionDuration: const Duration(milliseconds: 150),
          reverseTransitionDuration: const Duration(milliseconds: 150),
          transitionsBuilder: (_, animation, __, child) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ));

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}
