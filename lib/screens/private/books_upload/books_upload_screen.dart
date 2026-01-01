import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silsila_e_azeemia_dashboard/widgets/private_scaffold.dart';

class BooksUploadScreen extends StatelessWidget {
  static const String routeName = '/books_upload';

  const BooksUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrivateScaffold(
      title: 'sidebar_books_upload'.tr(),
      body: Center(child: Text('sidebar_books_upload'.tr())),
    );
  }
}
