import 'package:flutter/material.dart';

abstract class DialogBase {
  bool enableSubmit = true;
  Widget buildAlert(BuildContext context, GlobalKey<ScaffoldState> state);
}
