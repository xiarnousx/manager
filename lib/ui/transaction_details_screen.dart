import 'package:flutter/material.dart';
import 'package:manager/db/transaction.dart';
import 'package:manager/models/journal_entry.dart';
import 'package:manager/models/status.dart';
import 'package:manager/util/calculator.dart';
import 'package:manager/util/formatter.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final JournalEntry tnx;

  TransactionDetailsScreen({@required this.tnx});

  @override
  _TransactionDetailsScreenState createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  List<JournalEntry> entries;
  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details'),
      ),
      body: Column(
        children: <Widget>[
          _getGeneralInfo(),
          Expanded(
            child: _getJournalsList(),
          ),
        ],
      ),
    );
  }

  String _getK(int index) {
    return statusM.get(index) == StatusEnum.GP ? '' : ' K';
  }

  Color _getColor(int index) {
    return statusM.get(index) == StatusEnum.GP ? Colors.red : Colors.green;
  }

  Widget _getJournalsList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final JournalEntry entry = entries[index];
        return Card(
          child: ListTile(
            dense: true,
            isThreeLine: true,
            title: Text(Formatter.formatDate(entry.journal.created_at)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '\$' +
                      Formatter.formatMoney(entry.journal.amount) +
                      _getK(entry.journal.status),
                  style: TextStyle(
                    color: _getColor(entry.journal.status),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            leading: CircleAvatar(
              backgroundColor:
                  statusM.getColorCode(statusM.get(entry.journal.status)),
              child: Text(statusM.getValue(statusM.get(entry.journal.status))),
            ),
          ),
        );
      },
      itemCount: entries != null ? entries.length : 0,
      shrinkWrap: true,
    );
  }

  Widget _getGeneralInfo() {
    return Card(
      child: ListTile(
        dense: true,
        isThreeLine: true,
        title: Text(widget.tnx.customer.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.tnx.dealer.name.toUpperCase() +
                "  " +
                Formatter.formatDate(widget.tnx.transaction.created_at)),
            Text(
              '\$' +
                  Formatter.formatMoney(widget.tnx.transaction.total_amount) +
                  ' K',
              style: TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$' +
                  Formatter.formatMoney(
                      Calculator.gain(widget.tnx.transaction)),
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: statusM.getColorCode(StatusEnum.N),
          child: Text(statusM.getValue(StatusEnum.N)),
        ),
        trailing: Column(
          children: <Widget>[
            Text(
              'D ' + Formatter.formatMoney(widget.tnx.transaction.dealer_rate),
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'C ' +
                  Formatter.formatMoney(widget.tnx.transaction.customer_rate),
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadData() async {
    entries = await transactionDb
        .getJournalEntriesForTransaction(widget.tnx.transaction.id);
    if (mounted) {
      setState(() {
        entries = entries;
      });
    }
  }
}
