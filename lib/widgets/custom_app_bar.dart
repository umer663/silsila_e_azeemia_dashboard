import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('title'.tr()),
          const SizedBox(width: 40), // Space between logo and links
          _buildNavLink(context, 'nav_home'.tr(), () {}),
          _buildNavLink(context, 'nav_about_us'.tr(), () {}),
          _buildNavLink(context, 'nav_books'.tr(), () {}),
          _buildNavLink(context, 'nav_digests'.tr(), () {}),
          _buildNavLink(context, 'nav_media_gallery'.tr(), () {}),
          _buildNavLink(context, 'nav_contact_us'.tr(), () {}),
          _buildNavLink(context, 'nav_login'.tr(), () {}),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    );
  }

  Widget _buildNavLink(BuildContext context, String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title, // Title is already translated by caller
          style: const TextStyle(
            fontFamily: 'NooriNastaleeq', // Explicitly set font to ensure it renders
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
