import 'package:flutter/material.dart';
import 'package:manager/db/transaction.dart';
import 'package:manager/models/journal_entry.dart';
import 'package:manager/models/status.dart';
import 'package:manager/ui/app_drawer.dart';
import 'package:manager/ui/floating_button.dart';
import 'package:manager/ui/transaction_details_screen.dart';
import 'package:manager/ui/transaction_dialog.dart';
import 'package:manager/util/calculator.dart';
import 'package:manager/util/formatter.dart';
import 'package:manager/util/transaction_button.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  TransactionDialog dialog = TransactionDialog();
  List<JournalEntry> entries;
  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final JournalEntry entry = entries[index];
          return Card(
            child: ListTile(
              dense: true,
              isThreeLine: true,
              title: Text(entry.customer.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(entry.dealer.name.toUpperCase() +
                      "  " +
                      Formatter.formatDate(entry.transaction.created_at)),
                  Text(
                    '\$' +
                        Formatter.formatMoney(entry.transaction.total_amount) +
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
                            Calculator.gain(entry.transaction)),
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              leading: CircleAvatar(
                backgroundColor: statusM.getColorCode(
                    statusM.get(entry.transaction.current_status)),
                child: Text(statusM
                    .getValue(statusM.get(entry.transaction.current_status))),
              ),
              trailing: TransactionButton.get(
                context: context,
                key: _globalKey,
                entry: entry,
              ),
              onTap: () {
                final page = MaterialPageRoute(
                  builder: (context) => TransactionDetailsScreen(tnx: entry),
                );
                Navigator.of(context).push(page);
              },
            ),
          );
        },
        itemCount: entries != null ? entries.length : 0,
        shrinkWrap: true,
      ),
      floatingActionButton: FloatingButton.get(context, dialog, _globalKey),
    );
  }

  Future<void> loadData() async {
    entries = await transactionDb.getJournalEntries();
    if (mounted) {
      setState(() {
        entries = entries;
      });
    }
  }
}
