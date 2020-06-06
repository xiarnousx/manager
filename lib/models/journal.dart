import 'package:flutter/material.dart';

class Journal {
  int id;
  int transaction_id;
  double amount;
  int status;
  String created_at;

  Journal({
    this.id = 0,
    @required this.transaction_id,
    @required this.amount,
    @required this.status,
    @required this.created_at,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id,
      'transaction_id': transaction_id,
      'amount': amount,
      'status': status,
      'created_at': created_at,
    };
  }
}
