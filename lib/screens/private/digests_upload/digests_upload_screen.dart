import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silsila_e_azeemia_dashboard/widgets/private_scaffold.dart';

class DigestsUploadScreen extends StatelessWidget {
  static const String routeName = '/digests_upload';

  const DigestsUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrivateScaffold(
      title: 'sidebar_digests_upload'.tr(),
      body: Center(child: Text('sidebar_digests_upload'.tr())),
    );
  }
}
