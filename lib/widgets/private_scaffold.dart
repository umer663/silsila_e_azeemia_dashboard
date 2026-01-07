import 'package:flutter/material.dart';
import 'package:silsila_e_azeemia_dashboard/widgets/side_bar.dart';

class PrivateScaffold extends StatelessWidget {
  final Widget body;
  final String title;

  const PrivateScaffold({super.key, required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontFamily: 'NooriNastaleeq')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: MediaQuery.of(context).size.width > 600 ? null : const SideBar(), // Use Drawer only for mobile
      body: Row(
        children: [
          // Responsive check for Sidebar on desktop could go here, for now using Drawer for simplicity or both.
          // If we want persistent sidebar:
          if (MediaQuery.of(context).size.width > 600) const SizedBox(width: 250, child: SideBar(isDrawer: false)),
          Expanded(child: body),
        ],
      ),
    );
  }
}
