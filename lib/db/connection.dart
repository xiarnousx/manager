import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart' as f;

class Connection {
  static final Connection _connection = Connection._singleton();

  Connection._singleton();

  factory Connection() {
    return _connection;
  }

  static final int version = 1;
  static sqlite.Database db;

  static Future<sqlite.Database> open() async {
    if (db == null) {
      final String path =
          f.join(await sqlite.getDatabasesPath(), 'manager_journal_entries.db');
      db = await sqlite.openDatabase(
        path,
        onCreate: (database, version) {
          _createCustomerTable(database);
          _createDealerTable(database);
          _createTransactionTable(database);
          _createJournalTable(database);
          _createBoxTable(database);
        },
        version: version,
      );
    }

    return db;
  }

  static void _createCustomerTable(sqlite.Database db) {
    final String sql =
        "CREATE TABLE customers(id INTEGER PRIMARY KEY, name TEXT);";
    db.execute(sql);
  }

  static void _createDealerTable(sqlite.Database db) {
    final String sql =
        "CREATE TABLE dealers(id INTEGER PRIMARY KEY, name TEXT);";
    db.execute(sql);
  }

  static void _createTransactionTable(sqlite.Database db) {
    final String sql =
        "CREATE TABLE transactions(id INTEGER PRIMARY KEY, customer_id INTEGER, dealer_id INTEGER, dealer_rate double, customer_rate double, current_status INTEGER, total_amount double, created_at datetime, FOREIGN KEY(dealer_id) REFERENCES dealers(id), FOREIGN KEY(customer_id) REFERENCES customers(id));";
    db.execute(sql);
  }

  static void _createJournalTable(sqlite.Database db) {
    final String sql =
        "CREATE TABLE journals(id INTEGER PRIMARY KEY, transaction_id INTEGER, amount double, status INTEGER, created_at datetime, FOREIGN KEY(transaction_id) REFERENCES transactions(id));";
    db.execute(sql);
  }

 static void _createBoxTable(sqlite.Database db) {
    final String sql =
        "CREATE TABLE box(id INTEGER PRIMARY KEY, current_amount_remaining DOUBLE, upper_limit_amount DOUBLE);";
    db.execute(sql);
    db.insert(
        'box',
        {
          'id': 1,
          'current_amount_remaining': 100.0,
          'upper_limit_amount': 100.0
        },
        conflictAlgorithm: sqlite.ConflictAlgorithm.replace);
  }
}

final Connection conn = Connection();
