import 'package:flutter/material.dart';
import 'package:orkestria/core/utils/colors.dart';
import 'package:orkestria/main.dart'; // NOTE: Consider injecting ThemeController via Provider.
import 'package:provider/provider.dart';

/// A loading row dashboard with animated gradient boxes.
class LoadingRowDashboard extends StatefulWidget {
  @override
  _LoadingRowDashboardState createState() => _LoadingRowDashboardState();
}

class _LoadingRowDashboardState extends State<LoadingRowDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Animation controller.

  @override
  void initState() {
    super.initState();
    _controller = AnimationController( // Initialize animation controller.
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
            const SizedBox(height: 16), // Spacing.
            Expanded(
              child: GridView.builder( // Grid view for loading boxes.
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns.
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1, // Aspect ratio of the grid items.
                ),
                itemBuilder: (context, index) {
                  return AnimatedGradientBox(animation: _controller); // Animated box.
                },
                itemCount: 2, // Number of items.
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
              opacity: 0.7, // Adjust opacity as needed
              child: Opacity(
                opacity: 0.1, // Adjust opacity as needed
                child: Center(
                  child: Icon(
                    Icons.flash_on,
                    color: Colors.yellow, // NOTE: Consider making this color dynamic.
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}