import 'package:manager/db/connection.dart';
import 'package:manager/models/customer.dart';
import 'package:manager/models/dealer.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class People {
  static final People _people = People._singleton();
  final String _dealers = 'dealers';
  final String _customers = 'customers';
  static sqlite.Database _db;

  People._singleton() {
    Future.delayed(Duration.zero, () async {
      _db = await Connection.open();
    });
  }

  factory People() {
    return _people;
  }

  Future<int> insertDealer(Dealer person) async {
    _db = await Connection.open();
    int id = await _db.insert(
      _dealers,
      person.toMap(),
      conflictAlgorithm: sqlite.ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<void> deleteDealer(int id) async {
    final bool hasTransaction = await hasTransactions('dealer_id', id);
    if (hasTransaction) {
      return;
    }
    _db = await Connection.open();
    await _db.delete(_dealers, where: 'id = ?', whereArgs: [id]);
  }

  Future<Dealer> findDealerById(int id) async {
    _db = await Connection.open();
    final List<Map<String, dynamic>> maps = await _db.query(
      _dealers,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.length == 0) {
      return null;
    }

    final Map<String, dynamic> map = maps.first;

    return Dealer(
      id: map['id'],
      name: map['name'],
    );
  }

  Future<List<Dealer>> getDealers() async {
    _db = await Connection.open();
    final List<Map<String, dynamic>> maps = await _db.query(_dealers);
    return List.generate(
      maps.length,
      (index) => Dealer(
        id: maps[index]['id'],
        name: maps[index]['name'],
      ),
    );
  }

  Future<int> insertCustomer(Customer person) async {
    _db = await Connection.open();
    int id = await _db.insert(
      _customers,
      person.toMap(),
      conflictAlgorithm: sqlite.ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<Customer> findCustomerById(int id) async {
    _db = await Connection.open();
    final List<Map<String, dynamic>> maps = await _db.query(
      _customers,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.length == 0) {
      return null;
    }

    final Map<String, dynamic> map = maps.first;

    return Customer(
      id: map['id'],
      name: map['name'],
    );
  }

  Future<void> deleteCustomer(int id) async {
    final bool hasTransaction = await hasTransactions('customer_id', id);
    if (hasTransaction) {
      return;
    }
    _db = await Connection.open();
    await _db.delete(_customers, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Customer>> getCustomers() async {
    _db = await Connection.open();
    final List<Map<String, dynamic>> maps = await _db.query(_customers);
    return List.generate(
      maps.length,
      (index) => Customer(
        id: maps[index]['id'],
        name: maps[index]['name'],
      ),
    );
  }

  Future<bool> hasTransactions(String field, int id) async {
    _db = await Connection.open();
    final String sql =
        "select count(id) as total from transactions where ${field} = ${id}";
    List<Map<String, dynamic>> maps = await _db.rawQuery(sql);
    return maps.first['total'] > 0;
  }
}

final People peopleDb = People();
