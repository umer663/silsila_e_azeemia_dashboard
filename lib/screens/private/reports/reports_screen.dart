import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silsila_e_azeemia_dashboard/widgets/private_scaffold.dart';

class ReportsScreen extends StatelessWidget {
  static const String routeName = '/reports';

  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrivateScaffold(
      title: 'sidebar_reports'.tr(),
      body: Center(child: Text('sidebar_reports'.tr())),
    );
  }
}
