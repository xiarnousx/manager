import 'package:manager/db/connection.dart';
import 'package:manager/models/the_box.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class Box {
  final int boxId = 1;
  final String _boxTableName = 'box';

  static final Box _box = Box._singleton();
  static sqlite.Database _db;

  Box._singleton();

  factory Box() {
    Future.delayed(Duration.zero, () async {
      _db = await Connection.open();
    });
    return _box;
  }

  Future<void> debit(double amount) async {
    _db = await Connection.open();
    TheBox box = await this.get();
    if (box.current_amount_remaining - amount < 0) {
      throw ArgumentError('You don\'t have enough funds');
    }
    box.current_amount_remaining -= amount;
    await _db.update(_boxTableName, box.toMap(),
        where: 'id = ?', whereArgs: [boxId]);
  }

  Future<void> credit(double amount) async {
    _db = await Connection.open();
    TheBox box = await this.get();
    if (box.current_amount_remaining + amount > box.upper_limit_amount) {
      throw ArgumentError('You\'r box is already closed');
    }
    box.current_amount_remaining += amount;
    await _db.update(_boxTableName, box.toMap(),
        where: 'id = ?', whereArgs: [boxId]);
  }

  Future<void> sync(double upperLimit) async {
    _db = await Connection.open();
    TheBox box = await this.get();
    if (box.upper_limit_amount != box.current_amount_remaining) {
      throw ArgumentError('Your box is not closed');
    }

    box.upper_limit_amount = box.current_amount_remaining = upperLimit;
    await _db.update(_boxTableName, box.toMap(),
        where: 'id = ?', whereArgs: [boxId]);
  }

  Future<void> topUp(double newLimit) async {
    _db = await Connection.open();
    TheBox box = await this.get();

    box.upper_limit_amount += newLimit;
    box.current_amount_remaining += newLimit;
    await _db.update(_boxTableName, box.toMap(),
        where: 'id = ?', whereArgs: [boxId]);
  }

  Future<TheBox> get() async {
    _db = await Connection.open();
    final List<Map<String, dynamic>> maps = await _db.query(
      _boxTableName,
      where: 'id = ?',
      whereArgs: [this.boxId],
    );

    if (maps.length == 0) {
      return null;
    }

    final Map<String, dynamic> map = maps.first;

    return TheBox(
      current_amount_remaining: map['current_amount_remaining'],
      upper_limit_amount: map['upper_limit_amount'],
    );
  }
}

final Box boxDb = Box();
