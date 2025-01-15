import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/orkestria/auth/presentation/routes/login_route.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Animation pour la taille (de 250 à 130)
    _sizeAnimation = Tween<double>(begin: 250, end: 100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Animation pour le déplacement vertical (de 0 à -50 pixels)
    _positionAnimation = Tween<double>(begin: 0, end: -240).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward(); // Démarre l'animation

    // Naviguer vers la page suivante après 2 secondes
    Timer(const Duration(seconds: 2), () {
      GoRouter.of(context).push(loginRoutePath);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _positionAnimation.value), // Déplacement vertical
              child: Transform.rotate(
                angle: _controller.value * 2.0 * 3.14159, // Rotation
                child: SizedBox(
                  width: _sizeAnimation.value, // Animation de la taille
                  height: _sizeAnimation.value,
                  child: child,
                ),
              ),
            );
          },
          child: Image.asset(
            'assets/images/logo_splash.png',
          ),
        ),
      ),
    );
  }
}
