import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/main.dart';
import 'package:orkestria/orkestria/profile/presentation/routes/profile_route.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants.dart';
import '../../../../core/utils/responsive.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context.read<MenuAppController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          const Text(
            "Orkestria",
            style: heading1,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        const Expanded(child: SearchField()),
        const ProfileCard()
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;

    return GestureDetector(
      onTap: (){
        GoRouter.of(context).push(profileRoutePath);
      },
      child: Container(
        margin: const EdgeInsets.only(left: defaultPadding),
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: isDarkMode ? secondaryColor:secondaryColorLight,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            isDarkMode ? Image.asset(
              "assets/images/profile-user.png",
              height: 24,
            ):
            Image.asset(
              "assets/images/profile-user-dark.png",
              height: 24,
            ),
            if (!Responsive.isMobile(context))
              const Padding(
                padding:
                EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: Text("abdelhak sifi"),
              ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatefulWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  // Create a FocusNode to manage the focus state
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Make sure that the focus is unfocused when the widget is initialized
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // The TextField gained focus, you can manage behavior here if needed
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the FocusNode when the widget is disposed
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      FocusScope.of(context).requestFocus(FocusNode());
    });

    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;

    return TextField(
      focusNode: _focusNode,
      autofocus: false,
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: isDarkMode ? secondaryColor : secondaryColorLight,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {
          },
          child: Container(
            padding: const EdgeInsets.all(defaultPadding * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.withOpacity(0.1) : Colors.grey.shade400,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
