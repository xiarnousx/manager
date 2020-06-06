import 'package:manager/db/connection.dart';
import 'package:manager/models/customer.dart';
import 'package:manager/models/dealer.dart';
import 'package:manager/models/dealer_summary.dart';
import 'package:manager/models/journal.dart';
import 'package:manager/models/journal_entry.dart';
import 'package:manager/models/status.dart';
import 'package:manager/models/transaction.dart' as Tnx;
import 'package:manager/util/calculator.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class Transaction {
  static final Transaction _transaction = Transaction._singleton();
  final String _transactions = 'transactions';
  final String _journals = 'journals';
  static sqlite.Database _db;

  Transaction._singleton();

  factory Transaction() {
    Future.delayed(Duration.zero, () async {
      _db = await Connection.open();
    });
    return _transaction;
  }

  Future<int> insertTransaction(Tnx.Transaction tnx) async {
    _db = await Connection.open();
    final int id = await _db.insert(
      _transactions,
      tnx.toMap(),
      conflictAlgorithm: sqlite.ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> insertJournal(Journal journal) async {
    _db = await Connection.open();
    final int id = await _db.insert(
      _journals,
      journal.toMap(),
      conflictAlgorithm: sqlite.ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<Tnx.Transaction> findTransactionById(int id) async {
    _db = await Connection.open();
    final List<Map<String, dynamic>> maps = await _db.query(
      _transactions,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.length == 0) {
      return null;
    }

    final Map<String, dynamic> map = maps.first;

    return Tnx.Transaction(
      id: map['id'],
      customer_id: map['customer_id'],
      dealer_id: map['dealer_id'],
      dealer_rate: map['dealer_rate'],
      customer_rate: map['customer_rate'],
      total_amount: map['total_amount'],
      current_status: map['current_status'],
      created_at: map['created_at'],
    );
  }

  Future<List<Tnx.Transaction>> getTransactions() async {
    _db = await Connection.open();
    final List<Map<String, dynamic>> maps = await _db.query(_transactions);
    return List.generate(
      maps.length,
      (index) => Tnx.Transaction(
        id: maps[index]['id'],
        customer_id: maps[index]['customer_id'],
        dealer_id: maps[index]['dealer_id'],
        dealer_rate: maps[index]['dealer_rate'],
        customer_rate: maps[index]['customer_rate'],
        total_amount: maps[index]['total_amount'],
        current_status: maps[index]['current_status'],
        created_at: maps[index]['created_at'],
      ),
    );
  }

  Future<List<Tnx.Transaction>> getTransactionsByDealerId(
      int dealerId /*, int index*/) async {
    _db = await Connection.open();
    final List<Map<String, dynamic>> maps = await _db
        .query(_transactions, where: "dealer_id = ? ", whereArgs: [dealerId]);
    return List.generate(
      maps.length,
      (index) => Tnx.Transaction(
        id: maps[index]['id'],
        customer_id: maps[index]['customer_id'],
        dealer_id: maps[index]['dealer_id'],
        dealer_rate: maps[index]['dealer_rate'],
        customer_rate: maps[index]['customer_rate'],
        total_amount: maps[index]['total_amount'],
        current_status: maps[index]['current_status'],
        created_at: maps[index]['created_at'],
      ),
    );
  }

  Future<Journal> findJournalById(int id) async {
    _db = await Connection.open();
    final List<Map<String, dynamic>> maps = await _db.query(
      _journals,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.length == 0) {
      return null;
    }

    final Map<String, dynamic> map = maps.first;

    return Journal(
      id: map['id'],
      transaction_id: map['transaction_id'],
      amount: map['amount'],
      status: map['status'],
      created_at: map['created_at'],
    );
  }

  Future<List<Journal>> getJournals(int transactionId) async {
    _db = await Connection.open();
    final List<Map<String, dynamic>> maps = await _db.query(
      _journals,
      where: 'transaction_id = ?',
      whereArgs: [transactionId],
    );
    return List.generate(
      maps.length,
      (index) => Journal(
        id: maps[index]['id'],
        transaction_id: maps[index]['transaction_id'],
        amount: maps[index]['amount'],
        status: maps[index]['status'],
        created_at: maps[index]['created_at'],
      ),
    );
  }

  Future<List<JournalEntry>> getJournalEntries() async {
    _db = await Connection.open();
    final String sql =
        "SELECT distinct transactions.*, transactions.id as tnx_id, transactions.created_at as tnx_created_at, journals.status " +
            ", dealers.name as dealer" +
            ", customers.name as customer" +
            " FROM transactions INNER JOIN journals ON transactions.id = journals.transaction_id " +
            " INNER JOIN dealers ON transactions.dealer_id = dealers.id " +
            " INNER JOIN customers ON transactions.customer_id = customers.id " +
            " where transactions.current_status = journals.status " +
            "ORDER BY transactions.created_at DESC";

    List<Map<String, dynamic>> maps = await _db.rawQuery(sql);
    return List.generate(
      maps.length,
      (index) => JournalEntry(
        journal: Journal(
          id: null,
          transaction_id: maps[index]['tnx_id'],
          amount: null,
          status: maps[index]['status'],
          created_at: null,
        ),
        transaction: Tnx.Transaction(
          id: maps[index]['tnx_id'],
          customer_id: maps[index]['customer_id'],
          dealer_id: maps[index]['dealer_id'],
          dealer_rate: maps[index]['dealer_rate'],
          customer_rate: maps[index]['customer_rate'],
          total_amount: maps[index]['total_amount'],
          current_status: maps[index]['current_status'],
          created_at: maps[index]['tnx_created_at'],
        ),
        customer: Customer(
          id: maps[index]['customer_id'],
          name: maps[index]['customer'],
        ),
        dealer: Dealer(
          id: maps[index]['dealer_id'],
          name: maps[index]['dealer'],
        ),
      ),
    );
  }

  Future<double> getCustomerRemainingAmount(JournalEntry entry) async {
    _db = await Connection.open();
    final StatusEnum customerRemaining = StatusEnum.CR;
    final int index = statusM.getIndex(customerRemaining);

    final String sql =
        "SELECT sum(amount) remaining from journals where transaction_id = ${entry.transaction.id} and status = $index";
    List<Map<String, dynamic>> maps = await _db.rawQuery(sql);

    return entry.transaction.total_amount -
        (maps.first['remaining'] == null ? 0 : maps.first['remaining']);
  }

  Future<double> getDealerRemainingAmount(JournalEntry entry) async {
    _db = await Connection.open();
    final StatusEnum boxRemaining = StatusEnum.BR;
    final int index = statusM.getIndex(boxRemaining);

    final String sql =
        "SELECT sum(amount) remaining from journals where transaction_id = ${entry.transaction.id} and status = $index";
    List<Map<String, dynamic>> maps = await _db.rawQuery(sql);

    return entry.transaction.total_amount -
        (maps.first['remaining'] == null ? 0 : maps.first['remaining']);
  }

  Future<void> updateStatusTransaction(int id, int index) async {
    _db = await Connection.open();
    await _db.update(_transactions, {"current_status": index},
        where: "id = ?", whereArgs: [id]);
  }

  Future<void> deleteTransaction(int id) async {
    _db = await Connection.open();
    await _db.delete(_journals, where: "transaction_id = ?", whereArgs: [id]);
    await _db.delete(_transactions, where: "id = ?", whereArgs: [id]);
  }

  Future<List<JournalEntry>> getJournalEntriesForTransaction(
      int transactionId) async {
    _db = await Connection.open();
    final String sql =
        "SELECT transactions.*, transactions.id as tnx_id, transactions.created_at as tnx_created_at, journals.*, journals.id as jo_id, journals.created_at as jo_created_at" +
            ", dealers.name as dealer" +
            ", customers.name as customer" +
            " FROM transactions INNER JOIN journals ON transactions.id = journals.transaction_id " +
            " INNER JOIN dealers ON transactions.dealer_id = dealers.id " +
            " INNER JOIN customers ON transactions.customer_id = customers.id " +
            " where transactions.id = $transactionId and journals.transaction_id = $transactionId and journals.status != 0 ORDER BY journals.created_at ASC";

    List<Map<String, dynamic>> maps = await _db.rawQuery(sql);
    return List.generate(
      maps.length,
      (index) => JournalEntry(
        journal: Journal(
          id: maps[index]['jo_id'],
          transaction_id: maps[index]['transaction_id'],
          amount: maps[index]['amount'],
          status: maps[index]['status'],
          created_at: maps[index]['jo_created_at'],
        ),
        transaction: Tnx.Transaction(
          id: maps[index]['tnx_id'],
          customer_id: maps[index]['customer_id'],
          dealer_id: maps[index]['dealer_id'],
          dealer_rate: maps[index]['dealer_rate'],
          customer_rate: maps[index]['customer_rate'],
          total_amount: maps[index]['total_amount'],
          current_status: maps[index]['current_status'],
          created_at: maps[index]['tnx_created_at'],
        ),
        customer: Customer(
          id: maps[index]['customer_id'],
          name: maps[index]['customer'],
        ),
        dealer: Dealer(
          id: maps[index]['dealer_id'],
          name: maps[index]['dealer'],
        ),
      ),
    );
  }

  Future<DealerSummary> getDealerSummary(int dealerId) async {
    _db = await Connection.open();
    DealerSummary summary = DealerSummary();
    // get number of transactions
    final String sql =
        "SELECT count(id) as total_count from transactions where dealer_id= $dealerId";
    List<Map<String, dynamic>> maps = await _db.rawQuery(sql);
    summary.total_count =
        maps.first['total_count'] == null ? 0 : maps.first['total_count'];
    // get sum total amount of transactions
    final String sql1 =
        "SELECT sum(total_amount) as total_amount from transactions where dealer_id= $dealerId";
    List<Map<String, dynamic>> maps1 = await _db.rawQuery(sql1);
    summary.total_amount =
        maps1.first['total_amount'] == null ? 0 : maps1.first['total_amount'];
    // get sum of cp and br journals
    summary.total_collect = 0;
    final String sql2 =
        "select id, total_amount from transactions where dealer_id = $dealerId";
    List<Map<String, dynamic>> maps2 = await _db.rawQuery(sql2);
    maps2.forEach((tnx) async {
      final current_total_amount = tnx['total_amount'];
      final List<JournalEntry> entries =
          await getJournalEntriesForTransaction(tnx['id']);
      entries.forEach((entry) {
        if (entry.transaction.current_status ==
            statusM.getIndex(StatusEnum.CP)) {
          summary.total_collect += entry.journal.amount;
        } else if (entry.transaction.current_status ==
            statusM.getIndex(StatusEnum.CR)) {
          summary.total_collect += entry.journal.amount;
        } else if (entry.transaction.current_status ==
                statusM.getIndex(StatusEnum.BR) &&
            entry.journal.status == statusM.getIndex(StatusEnum.BR)) {
          summary.total_collect += current_total_amount - entry.journal.amount;
          print(summary.total_collect);
        }
      });
    });
    // calculate total gain
    List<Tnx.Transaction> tnxes = await getTransactionsByDealerId(
        dealerId /*statusM.getIndex(StatusEnum.BP)*/);
    summary.total_gain = 0;
    tnxes.forEach((currentTnx) {
      summary.total_gain += Calculator.gain(currentTnx);
    });
    return summary;
  }
}

final Transaction transactionDb = Transaction();
