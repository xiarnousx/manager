import 'package:flutter/material.dart';
import 'package:manager/db/transaction.dart';
import 'package:manager/models/journal.dart';
import 'package:manager/models/status.dart';
import 'package:manager/models/transaction.dart' as Model;
import 'package:manager/ui/customer_dropdown.dart';
import 'package:manager/ui/dealer_dropdown.dart';
import 'package:manager/ui/dialog_base.dart';

class TransactionDialog extends DialogBase {
  int _customerId;
  int _dealerId;

  final dealerRateCtrl = TextEditingController();
  final customerRateCtrl = TextEditingController();
  final totalAmountCtrl = TextEditingController();

  Widget buildAlert(BuildContext context, GlobalKey<ScaffoldState> state) {
    return AlertDialog(
      title: Text('New Transaction Deal'),
      elevation: 2,
      content: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              DealerDropdown(cb: (id) {
                return _dealerId = id;
              }),
              CustomerDropdown(cb: (id) {
                return _customerId = id;
              }),
              TextField(
                controller: totalAmountCtrl,
                decoration: InputDecoration(
                  hintText: 'Total Amount \$',
                ),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              TextField(
                controller: dealerRateCtrl,
                decoration: InputDecoration(
                  hintText: 'Dealer Rate NLira',
                ),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              TextField(
                controller: customerRateCtrl,
                decoration: InputDecoration(
                  hintText: 'Customer Rate NLira',
                ),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              RaisedButton(
                child: Text(
                  'Save Transaction',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.green,
                onPressed: () async {
                  if (!enableSubmit) {
                    print('2x Hit');
                    return;
                  }

                  final int dealer_id = _dealerId;
                  final int customer_id = _customerId;
                  final double total_amount =
                      double.tryParse(totalAmountCtrl.text);
                  final double dealer_rate =
                      double.tryParse(dealerRateCtrl.text);
                  final double customer_rate =
                      double.tryParse(customerRateCtrl.text);

                  if (dealer_id == null ||
                      customer_id == null ||
                      total_amount == null ||
                      dealer_rate == null ||
                      customer_rate == null) {
                    SnackBar bar = SnackBar(
                      content: Text('All fields are required'),
                      duration: Duration(
                        seconds: 1,
                      ),
                      backgroundColor: Colors.green,
                    );
                    state.currentState.showSnackBar(bar);
                    enableSubmit = true;
                    return;
                  }

                  enableSubmit = false;
                  final Status status = Status();

                  final int tnxId =
                      await transactionDb.insertTransaction(Model.Transaction(
                    dealer_id: dealer_id,
                    customer_id: customer_id,
                    dealer_rate: dealer_rate,
                    customer_rate: customer_rate,
                    total_amount: total_amount,
                    current_status: status.getIndex(StatusEnum.N),
                    created_at: DateTime.now().toIso8601String(),
                  ));
  enableSubmit = true;
                  await transactionDb.insertJournal(Journal(
                    transaction_id: tnxId,
                    status: status.getIndex(StatusEnum.N),
                    created_at: DateTime.now().toIso8601String(),
                    amount: 0.0,
                  ));

                  totalAmountCtrl.text = '';
                  dealerRateCtrl.text = '';
                  customerRateCtrl.text = '';

                  Navigator.of(context).pop();
                  enableSubmit = true;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
