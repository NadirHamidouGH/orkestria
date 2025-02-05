import 'package:flutter/material.dart';
import 'package:orkestria/core/utils/colors.dart';
import 'package:orkestria/main.dart'; // NOTE: Consider injecting ThemeController via Provider rather than direct import.
import 'package:orkestria/orkestria/dashboard/presentation/widgets/load_widget_logo.dart';
import 'package:orkestria/orkestria/dashboard/presentation/widgets/load_widget_logo_dark.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

/// Widget displaying a live camera feed.
class CameraLiveView extends StatefulWidget {
  final String videoUrl; // URL of the video stream.
  final String cameraName; // Name of the camera.

  CameraLiveView({required this.videoUrl, required this.cameraName});

  @override
  _CameraLiveViewState createState() => _CameraLiveViewState();
}

class _CameraLiveViewState extends State<CameraLiveView> {
  late VideoPlayerController _controller; // Controller for the video player.

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl) // Initialize the video player.
      ..initialize().then((_) {
        setState(() {
          _controller.play(); // Start playing the video once initialized.
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the video player controller.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context); // Access ThemeController.
    final isDarkMode = themeController.isDarkMode;

    return Scaffold(
      appBar: AppBar( // App bar with camera name.
        backgroundColor: isDarkMode ? secondaryColor : secondaryColorLight,
        title: Text(
          'Live Camera Feed ${widget.cameraName}',
          style: TextStyle(
              fontSize: 18, color: isDarkMode ? Colors.white : Colors.black87),
        ),
      ),
      body: Center( // Centers the video player or loader.
        child: _controller.value.isInitialized // Show video if initialized.
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : isDarkMode // Show appropriate loader based on theme.
            ? const LoaderWidget()
            : const LoaderDarkWidget(),
      ),
      floatingActionButton: FloatingActionButton( // Play/pause button.
        backgroundColor: Colors.white,
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.black,
        ),
      ),
    );
  }
}