import 'package:flutter/material.dart';
import 'package:manager/db/transaction.dart';
import 'package:manager/models/journal_entry.dart';
import 'package:manager/models/payment.dart';
import 'package:manager/models/status.dart';
import 'package:manager/ui/payment_dialog.dart';
import 'package:manager/util/calculator.dart';

class TransactionButton {
  static Widget get({
    @required BuildContext context,
    @required GlobalKey<ScaffoldState> key,
    @required JournalEntry entry,
  }) {
    final Color color =
        statusM.getColorCode(statusM.get(entry.transaction.current_status));
    final String text =
        TransactionButton._getText(entry.transaction.current_status);

    return RaisedButton(
      color: color,
      elevation: 3,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () async {
        final Payment payment = Payment(
          hint: _getHint(entry.transaction.current_status),
          text: _getText(entry.transaction.current_status),
          color: color,
          amount: await _getAmount(entry.transaction.current_status, entry),
          current: statusM.get(entry.transaction.current_status),
          next: statusM.getNext(entry.transaction.current_status),
          entry: entry,
          context: context,
          key: key,
        );

        showDialog(
          context: context,
          builder: (BuildContext context) {
            final PaymentDialog dialog = PaymentDialog();
            return dialog.build(payment);
          },
          barrierDismissible: false,
        );
      },
    );
  }

  static Future<double> _getAmount(
      int current_status, JournalEntry entry) async {
    final StatusEnum status = statusM.get(current_status);
    switch (status) {
      case StatusEnum.N:
        return entry.transaction.total_amount;
      case StatusEnum.CR:
        return await transactionDb.getCustomerRemainingAmount(entry);
        break;
      case StatusEnum.CP:
        return entry.transaction.total_amount;
      case StatusEnum.BR:
        return await transactionDb.getDealerRemainingAmount(entry);
        break;
      case StatusEnum.BP:
        return Calculator.gain(entry.transaction);
        break;
      case StatusEnum.GP:
        return Calculator.gain(entry.transaction);
        break;
    }
  }

  static String _getHint(int current_status) {
    final StatusEnum status = statusM.get(current_status);
    switch (status) {
      case StatusEnum.N:
        return 'Pay customer amount \$';
      case StatusEnum.CR:
        return 'Pay customer remaining amount \$';
        break;
      case StatusEnum.CP:
        return 'Collect from dealer amount \$';
      case StatusEnum.BR:
        return 'Collect from dealer remaining amount \$';
        break;
      case StatusEnum.BP:
        return 'Go and get your gain \$';
        break;
      case StatusEnum.GP:
        return 'Are your sure? This means you have received your gain!';
        break;
    }
  }

  static String _getText(int current_status) {
    final StatusEnum status = statusM.get(current_status);
    switch (status) {
      case StatusEnum.N:
      case StatusEnum.CR:
        return 'Pay';
        break;
      case StatusEnum.CP:
      case StatusEnum.BR:
        return 'Collect';
        break;
      case StatusEnum.BP:
        return 'Get Gain';
        break;
      case StatusEnum.GP:
        return 'Delete';
        break;
    }
  }
}
