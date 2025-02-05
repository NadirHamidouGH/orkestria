import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// A widget displaying a dark-themed loading indicator with a logo.
class LoaderDarkWidget extends StatelessWidget {
  const LoaderDarkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center( // Centers the loading indicator.
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ensures the column takes up minimal space.
        children: [
          SizedBox( // Contains the spinning animation and the logo.
            height: 150,
            width: 150,
            child: Stack( // Use a Stack to overlay the logo on the animation.
              alignment: Alignment.center,
              children: [
                const SpinKitFadingCircle( // The spinning animation.
                  color: Colors.black87, // Animation color. // NOTE: Consider making this color dynamic based on the theme.
                  size: 110.0,
                ),
                Image.asset( // The logo image.
                  'assets/images/logo_splash_dark.png',
                  height: 60,
                  width: 60,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), // Spacing below the indicator.
          // Text("Loading..."), // NOTE: Consider adding a loading text (perhaps customizable via a parameter).
        ],
      ),
    );
  }
}