import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:orkestria/main.dart'; // NOTE: Consider injecting ThemeController and MenuAppController via Provider.
import 'package:orkestria/orkestria/profile/presentation/routes/profile_route.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants.dart';
import '../../../../core/utils/responsive.dart';

/// Header section of the dashboard.
class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context)) // Menu button on smaller screens.
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context.read<MenuAppController>().controlMenu, // Control the menu.
          ),
        if (!Responsive.isMobile(context)) // App title on larger screens.
          const Text(
            "Orkestria",
            style: heading1,
          ),
        if (!Responsive.isMobile(context)) // Spacer on larger screens.
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        const Expanded(child: SearchField()), // Search field.
        const ProfileCard() // Profile card.
      ],
    );
  }
}

/// Displays user profile information.
class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context); // Access ThemeController.
    final isDarkMode = themeController.isDarkMode;

    return GestureDetector( // Makes the profile card tappable.
      onTap: () {
        GoRouter.of(context).push(profileRoutePath); // Navigate to profile screen.
      },
      child: Container( // Container for styling.
        margin: const EdgeInsets.only(left: defaultPadding),
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: isDarkMode ? secondaryColor : secondaryColorLight,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            isDarkMode // Profile image based on theme.
                ? Image.asset(
              "assets/images/profile-user.png",
              height: 24,
            )
                : Image.asset(
              "assets/images/profile-user-dark.png",
              height: 24,
            ),
            if (!Responsive.isMobile(context)) // User name on larger screens.
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: Text("abdelhak sifi"), // NOTE: Consider making the user name dynamic.
              ),
            const Icon(Icons.keyboard_arrow_down), // Dropdown icon.
          ],
        ),
      ),
    );
  }
}

/// Search field widget.
class SearchField extends StatefulWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late FocusNode _focusNode; // Focus node for the text field.

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(); // Initialize the focus node.
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose of the focus node.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // NOTE: This is likely not needed and can cause issues.  Focus should be handled by user interaction or other logic.
    Future.microtask(() {
      FocusScope.of(context).requestFocus(FocusNode());
    });

    final themeController = Provider.of<ThemeController>(context); // Access ThemeController.
    final isDarkMode = themeController.isDarkMode;

    return TextField(
      focusNode: _focusNode, // Assign the focus node.
      autofocus: false, // Disable initial autofocus.
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: isDarkMode ? secondaryColor : secondaryColorLight,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell( // Search icon button.
          onTap: () {
            // Perform search action here.
          },
          child: Container(
            padding: const EdgeInsets.all(defaultPadding * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.withOpacity(0.1) : Colors.grey.shade400,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}