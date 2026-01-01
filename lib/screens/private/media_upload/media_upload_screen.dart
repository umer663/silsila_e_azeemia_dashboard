import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silsila_e_azeemia_dashboard/widgets/private_scaffold.dart';

class MediaUploadScreen extends StatelessWidget {
  static const String routeName = '/media_upload';

  const MediaUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrivateScaffold(
      title: 'sidebar_media_upload'.tr(),
      body: Center(child: Text('sidebar_media_upload'.tr())),
    );
  }
}
