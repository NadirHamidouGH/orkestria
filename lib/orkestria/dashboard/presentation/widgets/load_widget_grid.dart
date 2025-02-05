import 'package:flutter/material.dart';
import 'package:orkestria/main.dart'; // NOTE: Consider injecting ThemeController via Provider.
import 'package:provider/provider.dart';
import '../../../../core/utils/colors.dart';

/// A loading grid dashboard with animated gradient boxes.
class LoadingGridDashboard extends StatefulWidget {
  @override
  _LoadingGridDashboardState createState() => _LoadingGridDashboardState();
}

class _LoadingGridDashboardState extends State<LoadingGridDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Animation controller for the gradient.

  @override
  void initState() {
    super.initState();
    _controller = AnimationController( // Initialize the animation controller.
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false); // Repeat the animation.
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder( // Grid view for the loading boxes.
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns.
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  return AnimatedGradientBox(animation: _controller); // Create animated box.
                },
                itemCount: 4, // Number of boxes.
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// An animated gradient box.
class AnimatedGradientBox extends StatelessWidget {
  final Animation<double> animation; // Animation for the gradient.

  const AnimatedGradientBox({required this.animation, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context); // Access ThemeController.
    final isDarkMode = themeController.isDarkMode;

    return AnimatedBuilder( // Animate the gradient.
      animation: animation,
      builder: (context, child) {
        return ShaderMask( // Apply the gradient shader.
          shaderCallback: (bounds) {
            return isDarkMode
                ? LinearGradient( // Gradient for dark mode.
              colors: const [
                secondaryColor,
                kPrimaryColor,
                secondaryColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-3.0 + 1.0 * animation.value, 0.0),
              end: Alignment(1.0 + 3.0 * animation.value, 0.0),
            ).createShader(bounds)
                : LinearGradient( // Gradient for light mode.
              colors: const [
                secondaryColorLight,
                kPrimaryColorLight,
                secondaryColorLight,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-3.0 + 1.0 * animation.value, 0.0),
              end: Alignment(1.0 + 3.0 * animation.value, 0.0),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: Container( // Container with rounded corners and icon.
            decoration: BoxDecoration(
              color: kPrimaryColor, // NOTE: Consider making this color dynamic.
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Opacity( // Opacity for the shimmer effect.
              opacity: 0.1,
              child: Center(
                child: Icon(
                  Icons.flash_on,
                  color: Colors.yellow, // NOTE: Consider making this color dynamic.
                  size: 40,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}