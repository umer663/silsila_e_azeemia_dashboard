import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silsila_e_azeemia_dashboard/widgets/custom_app_bar.dart';

class MediaGalleryScreen extends StatelessWidget {
  static const String routeName = '/media_gallery';

  const MediaGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(child: Text('nav_media_gallery'.tr())),
    );
  }
}
