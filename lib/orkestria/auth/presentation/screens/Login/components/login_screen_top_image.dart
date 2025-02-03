import 'package:flutter/material.dart';
import 'package:orkestria/main.dart';
import 'package:provider/provider.dart';


class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;

    return Column(
      children: [
        isDarkMode ? Image.asset("assets/images/logo.png",height: 150,):Image.asset("assets/images/logo_dark.png",height: 150,),
        Row(
          children: [
            // const Spacer(),
            Expanded(
              flex: 22,
              child: Image.asset("assets/images/login.png")
            ),
            // const Spacer(),
          ],
        ),
        // const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
