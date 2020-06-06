import 'package:flutter/material.dart';
import 'package:manager/models/transaction.dart';
import 'package:manager/models/customer.dart';
import 'package:manager/models/dealer.dart';
import 'package:manager/models/journal.dart';

class JournalEntry {
  Transaction transaction;
  Journal journal;
  Dealer dealer;
  Customer customer;

  JournalEntry({
    @required this.transaction,
    @required this.journal,
    @required this.dealer,
    @required this.customer,
  });
}
