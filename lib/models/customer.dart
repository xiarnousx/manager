import 'package:flutter/material.dart';

class Customer {
  int id;
  String name;

  Customer({
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
