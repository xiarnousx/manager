import 'package:flutter/material.dart';
import 'package:manager/db/box.dart';
import 'package:manager/db/transaction.dart';
import 'package:manager/models/journal.dart';
import 'package:manager/models/journal_entry.dart';
import 'package:manager/models/payment.dart';
import 'package:manager/models/status.dart';
import 'package:manager/util/calculator.dart';
import 'package:manager/util/formatter.dart';

class PaymentDialog {
  final amountCtrl = TextEditingController();
  bool _enableSubmit = true;

  Widget build(Payment payment) {
    amountCtrl.text = payment.amount.toString();
    return AlertDialog(
      title: Text(
        payment.text +
            _getTextSuffix(payment.current, payment.amount, payment.entry),
        style: TextStyle(
          fontSize: 12,
        ),
      ),
      elevation: 2,
      content: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              if (payment.current != StatusEnum.BP &&
                  payment.current != StatusEnum.GP)
                TextField(
                  controller: amountCtrl,
                  decoration: InputDecoration(
                    hintText: payment.hint,
                  ),
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              if (payment.current == StatusEnum.BP ||
                  payment.current == StatusEnum.GP)
                Text(
                  payment.hint,
                  style: TextStyle(
                    color: payment.color,
                    fontSize: 18,
                  ),
                ),
              RaisedButton(
                child: Text(
                  payment.text,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: payment.color,
                onPressed: () async {
                  if (!_enableSubmit) {
                    return;
                  }

                  if (payment.current != StatusEnum.GP) {
                    final double amount = double.tryParse(amountCtrl.text);

                    if (null == amount) {
                      SnackBar bar = SnackBar(
                        content: Text('All fields are required'),
                        duration: Duration(
                          seconds: 1,
                        ),
                        backgroundColor: Colors.green,
                      );
                      payment.key.currentState.showSnackBar(bar);
                      return;
                    }

                    if (amount > payment.entry.transaction.total_amount &&
                        payment.current != StatusEnum.BP) {
                      SnackBar bar = SnackBar(
                        content: Text(
                            'Payment can not exceed amount \$${payment.entry.transaction.total_amount}'),
                        duration: Duration(
                          seconds: 1,
                        ),
                        backgroundColor: Colors.green,
                      );
                      payment.key.currentState.showSnackBar(bar);
                      return;
                    }

                    if (amount <= 0) {
                      SnackBar bar = SnackBar(
                        content: Text('Payment can not be negative.'),
                        duration: Duration(
                          seconds: 1,
                        ),
                        backgroundColor: Colors.green,
                      );
                      payment.key.currentState.showSnackBar(bar);
                      return;
                    }
                    bool isDebit = true;
                    bool isGainPhase = false;
                    Journal tnx = Journal(
                      amount: amount,
                      status: null,
                      transaction_id: payment.entry.transaction.id,
                      created_at: DateTime.now().toIso8601String(),
                    );

                    if (payment.current == StatusEnum.N &&
                        amount == payment.entry.transaction.total_amount) {
                      tnx.status = statusM.getIndex(StatusEnum.CP);
                      isDebit = true;
                    } else if ((payment.current == StatusEnum.N ||
                        payment.current == StatusEnum.CR)) {
                      double remainingCR = await transactionDb
                          .getCustomerRemainingAmount(payment.entry);
                      if (remainingCR == amount) {
                        tnx.status = statusM.getIndex(StatusEnum.CP);
                      } else {
                        tnx.status = statusM.getIndex(StatusEnum.CR);
                      }
                      isDebit = true;
                    } else if (payment.current == StatusEnum.CP &&
                        amount == payment.entry.transaction.total_amount) {
                      tnx.status = statusM.getIndex(StatusEnum.BP);
                      isDebit = false;
                    } else if ((payment.current == StatusEnum.CP ||
                        payment.current == StatusEnum.BR)) {
                      double remainingBR = await transactionDb
                          .getDealerRemainingAmount(payment.entry);
                      if (remainingBR == amount) {
                        tnx.status = statusM.getIndex(StatusEnum.BP);
                      } else {
                        tnx.status = statusM.getIndex(StatusEnum.BR);
                      }
                      isDebit = false;
                    } else if (payment.current == StatusEnum.BP) {
                      tnx.status = statusM.getIndex(StatusEnum.GP);
                      isGainPhase = true;
                    }

                    try {
                      _enableSubmit = false;
                      if (!isGainPhase && isDebit) {
                        await boxDb.debit(amount);
                      } else if (!isGainPhase && !isDebit) {
                        await boxDb.credit(amount);
                      }
                      if (isGainPhase) {
                        tnx.amount = Calculator.gain(payment.entry.transaction);
                      }
                      await transactionDb.updateStatusTransaction(
                          tnx.transaction_id, tnx.status);
                      await transactionDb.insertJournal(tnx);
                    } catch (e) {
                      SnackBar bar = SnackBar(
                        content: Text(e.toString()),
                        duration: Duration(
                          seconds: 1,
                        ),
                        backgroundColor: Colors.green,
                      );
                      payment.key.currentState.showSnackBar(bar);
                    }
                    // db logic here
                    amountCtrl.text = '';
                  } else if (payment.current == StatusEnum.GP) {
                    _enableSubmit = false;
                    await transactionDb
                        .deleteTransaction(payment.entry.transaction.id);
                  }

                  Navigator.of(payment.context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTextSuffix(StatusEnum current, double amount, JournalEntry entry) {
    switch (current) {
      case StatusEnum.CR:
      case StatusEnum.N:
        return ' to customer ${entry.customer.name} amount \$' +
            Formatter.formatMoney(amount);
        break;
      case StatusEnum.BR:
      case StatusEnum.CP:
        return ' from dealer ${entry.dealer.name} amount \$' +
            Formatter.formatMoney(amount);
        break;
      case StatusEnum.BP:
        return ' from dealer ${entry.dealer.name}  amount \$' +
            Formatter.formatMoney(amount);
        break;
      case StatusEnum.GP:
        return ' record!';
        break;
    }
  }
}
