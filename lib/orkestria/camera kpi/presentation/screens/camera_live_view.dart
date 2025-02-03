import 'package:flutter/material.dart';
import 'package:orkestria/core/utils/colors.dart';
import 'package:orkestria/main.dart';
import 'package:orkestria/orkestria/dashboard/presentation/widgets/load_widget_logo.dart';
import 'package:orkestria/orkestria/dashboard/presentation/widgets/load_widget_logo_dark.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CameraLiveView extends StatefulWidget {
  final String videoUrl;
  final String cameraName;

  CameraLiveView({required this.videoUrl,required this.cameraName});

  @override
  _CameraLiveViewState createState() => _CameraLiveViewState();
}

class _CameraLiveViewState extends State<CameraLiveView> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialiser le contrôleur et démarrer la lecture dès que la vidéo est prête
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          // Une fois la vidéo initialisée, démarrer la lecture automatiquement
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? secondaryColor : secondaryColorLight,
        title: Text('Live Camera Feed ${widget.cameraName}', style: TextStyle(fontSize: 18, color: isDarkMode ? Colors.white: Colors.black87),),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : isDarkMode ? const LoaderWidget():const LoaderDarkWidget(),
      ),
      floatingActionButton: FloatingActionButton(
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
