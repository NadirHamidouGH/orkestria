import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/core/constants.dart';
import 'package:orkestria/main.dart';
import 'package:orkestria/orkestria/auth/presentation/routes/signup_route.dart';
import 'package:orkestria/orkestria/main/main_screen.dart';
import 'package:provider/provider.dart';
import '../../../widgets/already_have_an_account_acheck.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>
              MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => MenuAppController(),
                  ),
                ],
                child: MainScreen(),
              ),));
            },
            child: Text(
              "Login".toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              GoRouter.of(context).push(signupRoutePath);
            },
          ),
        ],
      ),
    );
  }
}
