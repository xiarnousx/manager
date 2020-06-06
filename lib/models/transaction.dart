import 'package:flutter/material.dart';

class Transaction {
  int id;
  int customer_id;
  int dealer_id;
  double dealer_rate;
  double customer_rate;
  int current_status;
  double total_amount;
  String created_at;

  Transaction({
    this.id = 0,
    @required this.customer_id,
    @required this.dealer_id,
    @required this.dealer_rate,
    @required this.customer_rate,
    @required this.current_status,
    @required this.total_amount,
    @required this.created_at,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id,
      'customer_id': customer_id,
      'dealer_id': dealer_id,
      'dealer_rate': dealer_rate,
      'customer_rate': customer_rate,
      'current_status': current_status,
      'total_amount': total_amount,
      'created_at': created_at,
    };
  }
}
