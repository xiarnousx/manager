import 'package:flutter/material.dart';

class TheBox {
  final int id = 1;
  double current_amount_remaining;
  double upper_limit_amount;

  TheBox({
    @required this.current_amount_remaining,
    @required this.upper_limit_amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'current_amount_remaining': current_amount_remaining,
      'upper_limit_amount': upper_limit_amount,
    };
  }
}
