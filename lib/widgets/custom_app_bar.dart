import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1024;

    return AppBar(
      automaticallyImplyLeading: false,
      leading: isDesktop
          ? null
          : PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (route) => Navigator.pushNamed(context, route),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                _buildPopupMenuItem('nav_home'.tr(), '/home'),
                _buildPopupMenuItem('nav_about_us'.tr(), '/about_us'),
                _buildPopupMenuItem('nav_books'.tr(), '/books'),
                _buildPopupMenuItem('nav_digests'.tr(), '/digests'),
                _buildPopupMenuItem('nav_media_gallery'.tr(), '/media_gallery'),
                _buildPopupMenuItem('nav_contact_us'.tr(), '/contact_us'),
                _buildPopupMenuItem('nav_login'.tr(), '/login'),
              ],
            ),
      title: isDesktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('title'.tr()),
                const SizedBox(width: 40), // Space between logo and links
                _buildNavLink(
                  context,
                  'nav_home'.tr(),
                  () => Navigator.pushNamed(context, '/home'),
                ),
                _buildNavLink(
                  context,
                  'nav_about_us'.tr(),
                  () => Navigator.pushNamed(context, '/about_us'),
                ),
                _buildNavLink(
                  context,
                  'nav_books'.tr(),
                  () => Navigator.pushNamed(context, '/books'),
                ),
                _buildNavLink(
                  context,
                  'nav_digests'.tr(),
                  () => Navigator.pushNamed(context, '/digests'),
                ),
                _buildNavLink(
                  context,
                  'nav_media_gallery'.tr(),
                  () => Navigator.pushNamed(context, '/media_gallery'),
                ),
                _buildNavLink(
                  context,
                  'nav_contact_us'.tr(),
                  () => Navigator.pushNamed(context, '/contact_us'),
                ),
                _buildNavLink(
                  context,
                  'nav_login'.tr(),
                  () => Navigator.pushNamed(context, '/login'),
                ),
              ],
            )
          : Text('title'.tr()),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String title, String route) {
    return PopupMenuItem<String>(
      value: route,
      child: Text(
        title,
        style: const TextStyle(fontFamily: 'NooriNastaleeq', fontSize: 18),
      ),
    );
  }

  Widget _buildNavLink(
    BuildContext context,
    String title,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title, // Title is already translated by caller
          style: const TextStyle(
            fontFamily:
                'NooriNastaleeq', // Explicitly set font to ensure it renders
            // removed fontWeight: FontWeight.bold as it might break the custom font rendering if weight is missing
            color: Colors.black87,
            fontWeight: FontWeight.normal,
            fontSize: 18, // Slightly larger for Nastaleeq readability
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
