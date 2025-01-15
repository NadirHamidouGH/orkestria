import 'package:flutter/material.dart';


class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("assets/images/logo.png",height: 150,),
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
