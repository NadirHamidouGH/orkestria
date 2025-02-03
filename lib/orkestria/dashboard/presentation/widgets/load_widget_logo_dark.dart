import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoaderDarkWidget extends StatelessWidget {
  const LoaderDarkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo qui tourne
            SizedBox(
              height: 150,
              width: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const SpinKitFadingCircle(
                    color: Colors.black87, // Couleur de l'animation
                    size: 110.0,
                  ),
                  // Image du logo
                  Image.asset(
                    'assets/images/logo_splash_dark.png',
                    height: 60,
                    width: 60,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Texte de chargement
          ],
        ),
      );
  }
}