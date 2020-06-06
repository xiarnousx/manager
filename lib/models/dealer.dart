import 'package:flutter/material.dart';

class Dealer {
  int id;
  String name;

  Dealer({
    this.id = 0,
    @required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id,
      'name': name,
    };
  }
}
