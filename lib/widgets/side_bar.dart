import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final bool isDrawer;

  const SideBar({super.key, this.isDrawer = true});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: const Text(
              'Admin Panel',
              style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'NooriNastaleeq'),
            ),
          ),
          _buildListTile(context, 'sidebar_dashboard', '/dashboard', Icons.dashboard),
          _buildListTile(context, 'sidebar_books_upload', '/books_upload', Icons.book),
          _buildListTile(context, 'sidebar_digests_upload', '/digests_upload', Icons.menu_book),
          _buildListTile(context, 'sidebar_media_upload', '/media_upload', Icons.perm_media),
          _buildListTile(context, 'sidebar_users_management', '/users_management', Icons.people),
          _buildListTile(context, 'sidebar_reports', '/reports', Icons.analytics),
          const Divider(),
          _buildListTile(context, 'nav_home', '/home', Icons.logout),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String titleKey, String routeName, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(titleKey.tr(), style: const TextStyle(fontFamily: 'NooriNastaleeq', fontSize: 16)),
      onTap: () {
        if (isDrawer) {
          Navigator.pop(context); // Close drawer only if it is a drawer
        }
        Navigator.pushReplacementNamed(context, routeName);
      },
    );
  }
}
