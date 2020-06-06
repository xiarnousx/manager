import 'package:flutter/material.dart';
import 'package:manager/ui/dialog_base.dart';

class FloatingButton {
  static FloatingActionButton get(BuildContext context, DialogBase dialog,
      GlobalKey<ScaffoldState> _globalKey) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              dialog.buildAlert(context, _globalKey),
          barrierDismissible: false,
        );
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.deepOrange,
    );
  }
}
