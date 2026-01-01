import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silsila_e_azeemia_dashboard/widgets/private_scaffold.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '/dashboard';

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrivateScaffold(
      title: 'sidebar_dashboard'.tr(),
      body: Center(child: Text('sidebar_dashboard'.tr())),
    );
  }
}
