import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/main.dart';
import 'package:orkestria/orkestria/main/presentation/routes/main_route.dart';
import 'package:provider/provider.dart';
import 'package:orkestria/domain/usecases/authenticate_usecase.dart';
import 'package:orkestria/core/constants.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController(text: "abdelhak");
  final TextEditingController passwordController = TextEditingController(text: "abdelhak123");
  bool isLoading = false;
  bool hidePasswod = true;
  String? errorMessage;

  // put it in separate business logic
  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Obtenez le UseCase depuis Provider
      final authenticateUseCase = Provider.of<AuthenticateUseCase>(context, listen: false);

      // Appelez la méthode d'authentification
      final isAuthenticated = await authenticateUseCase(email, password);

      if (isAuthenticated) {
        // Si l'authentification réussie, navigate to main screen
        GoRouter.of(context).go(mainRoutePath);


      } else {
        setState(() {
          errorMessage = 'Invalid username or password';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error : authentication error';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              hintText: "Username",
              prefixIcon: Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: hidePasswod,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(4),
                  child: GestureDetector(
                      onTap: (){
                        hidePasswod = !hidePasswod;
                        setState(() {});
                      },
                      child: Icon(hidePasswod ? Icons.lock:Icons.lock_open_outlined))
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            // style: ButtonStyle(backgroundColor: gre),
            onPressed: isLoading ? null : _login,  // Disable button when loading
            child: isLoading
                ? const SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(color: kPrimaryColor))
                : Text(
              style: TextStyle(
                fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : Colors.black87),
              "Login".toUpperCase(),
              // style: const TextStyle(color: Colors.white),
            ),
          ),
           (errorMessage != null)?
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ):const SizedBox(height: 30,),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}
