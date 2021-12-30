import 'package:flutter/material.dart';
import 'package:flutter_app/ui/common/buttons.dart';

class OkCancelDialog extends StatelessWidget {
  const OkCancelDialog({Key? key, required this.title, required this.desc}) : super(key: key);
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(title: Text(title), content: Text(desc), actions: [
      AppBtn(
        label: 'Cancel',
        onTap: () => Navigator.of(context).pop(false),
      ),
      AppBtn(
        label: 'Ok',
        onTap: () => Navigator.of(context).pop(true),
      ),
    ]);
  }
}
