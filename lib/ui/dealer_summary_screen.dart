import 'package:flutter/material.dart';
import 'package:manager/db/transaction.dart';
import 'package:manager/models/dealer.dart';
import 'package:manager/models/dealer_summary.dart';
import 'package:manager/util/formatter.dart';

class DealerSummaryScreen extends StatefulWidget {
  final Dealer dealer;

  DealerSummaryScreen({this.dealer});

  @override
  _DealerSummaryScreenState createState() => _DealerSummaryScreenState();
}

class _DealerSummaryScreenState extends State<DealerSummaryScreen> {
  DealerSummary summary;
  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dealer.name + ' Summary'),
      ),
      body: summary != null
          ? SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Table(
                    border: TableBorder.all(
                      width: 1.0,
                      color: Colors.green,
                    ),
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Text(
                              'Total Transactions',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Text(
                                summary.total_count.toString(),
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Text(
                              'Total Amount',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 16,
                              ),
                              child: Text(
                                '\$' +
                                    Formatter.formatMoney(
                                        summary.total_amount) +
                                    ' K',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.green,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Text(
                              'Total Collection',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 16,
                              ),
                              child: Text(
                                '\$' +
                                    Formatter.formatMoney(
                                        summary.total_collect) +
                                    ' K',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.red,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Text(
                              'Total Gain',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 16,
                              ),
                              child: Text(
                                '\$' +
                                    Formatter.formatMoney(summary.total_gain),
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.blue,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(),
    );
  }

  Future<void> loadData() async {
    summary = await transactionDb.getDealerSummary(widget.dealer.id);
    if (mounted) {
      setState(() {
        summary = summary;
      });
    }
  }
}
