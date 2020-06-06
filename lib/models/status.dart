import 'package:flutter/material.dart';

enum StatusEnum { N, CR, CP, BR, BP, GP }

class Status {
  static final Status _status = Status._singleton();

  final Map<String, Color> _code = {
    'N': Colors.blue,
    'CR': Colors.orange[700],
    'CP': Colors.yellow[700],
    'BR': Colors.red,
    'BP': Colors.deepPurple,
    'GP': Colors.green,
  };

  Status._singleton();

  factory Status() {
    return _status;
  }

  String getValue(StatusEnum entry) {
    final int index = entry.index;
    final String status = StatusEnum.values[index].toString();
    return status.substring(status.indexOf('.') + 1);
  }

  int getIndex(StatusEnum entry) => entry.index;

  StatusEnum get(int index) {
    if (index < 0 || index > StatusEnum.values.length) {
      throw ArgumentError('index must be between 0 and 5 inclusive.');
    }
    return StatusEnum.values[index];
  }

  StatusEnum getNext(int index) {
    if (index < 0 || index > StatusEnum.values.length) {
      throw ArgumentError('index must be between 0 and 5 inclusive.');
    }
    int next = index++;

    if (next == StatusEnum.values.length) {
      --next;
    }

    return StatusEnum.values[next];
  }

  Color getColorCode(StatusEnum entry) {
    final String code = this.getValue(entry);
    return this._code[code];
  }
}

final Status statusM = Status();
