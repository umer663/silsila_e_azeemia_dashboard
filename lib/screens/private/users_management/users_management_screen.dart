import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silsila_e_azeemia_dashboard/widgets/private_scaffold.dart';

class UsersManagementScreen extends StatelessWidget {
  static const String routeName = '/users_management';

  const UsersManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrivateScaffold(
      title: 'sidebar_users_management'.tr(),
      body: Center(child: Text('sidebar_users_management'.tr())),
    );
  }
}
