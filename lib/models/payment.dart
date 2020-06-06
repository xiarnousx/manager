import 'package:flutter/material.dart';
import 'package:manager/models/journal_entry.dart';
import 'package:manager/models/status.dart';

class Payment {
  String text;
  String hint;
  double amount;
  JournalEntry entry;
  StatusEnum current;
  StatusEnum next;
  Color color;
  BuildContext context;
  GlobalKey<ScaffoldState> key;

  Payment({
    @required this.text,
    @required this.hint,
    @required this.amount,
    @required this.entry,
    @required this.current,
    @required this.next,
    @required this.color,
    this.context,
    this.key,
  });
}
