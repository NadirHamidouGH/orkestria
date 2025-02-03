import 'package:flutter/material.dart';
import 'package:orkestria/core/utils/colors.dart';
import 'package:orkestria/main.dart';
import 'package:provider/provider.dart';


class LoadingRowDashboard extends StatefulWidget {
  @override
  _LoadingRowDashboardState createState() => _LoadingRowDashboardState();
}

class _LoadingRowDashboardState extends State<LoadingRowDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            const SizedBox(height: 16), // Espacement
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return AnimatedGradientBox(animation: _controller);
                },
                itemCount: 2, // Nombre d'éléments
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedGradientBox extends StatelessWidget {
  final Animation<double> animation;

  const AnimatedGradientBox({required this.animation, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
             return isDarkMode ? LinearGradient(
              colors: const [
                secondaryColor,
                kPrimaryColor,
                secondaryColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-3.0 + 1.0 * animation.value, 0.0),
              end: Alignment(1.0 + 3.0 * animation.value, 0.0),
            ).createShader(bounds):
                                LinearGradient(
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
          child: Container(
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Opacity(
              opacity: 0.7, // Adjust opacity as needed
              child: Opacity(
                opacity: 0.1, // Adjust opacity as needed
                child: Center(
                        child: Icon(
                          Icons.flash_on,
                          color: Colors.yellow[700],
                          size: 40,
                        ),
                      ),
                 // Use the provided item widget
              ), // Use the provided item widget
            ),
          ),
        );
      },
    );
  }
}
