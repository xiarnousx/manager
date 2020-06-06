import 'package:flutter/material.dart';
import 'package:manager/db/box.dart';
import 'package:manager/ui/dialog_base.dart';

class BoxDialog extends DialogBase {
  final amountCtrl = TextEditingController();

  Widget buildAlert(BuildContext context, GlobalKey<ScaffoldState> state) {
    return AlertDialog(
      title: Text('Top Up Box'),
      elevation: 2,
      content: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              TextField(
                controller: amountCtrl,
                decoration: InputDecoration(
                  hintText: 'Top Up Box',
                ),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
              RaisedButton(
                child: Text(
                  'Top Up Box',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.green,
                onPressed: () async {
                  final double amount = double.tryParse(amountCtrl.text);

                  if (amount == null) {
                    SnackBar bar = SnackBar(
                      content: Text('All fields are required'),
                      duration: Duration(
                        seconds: 1,
                      ),
                      backgroundColor: Colors.green,
                    );
                    state.currentState.showSnackBar(bar);
                    return;
                  }

                  await boxDb.topUp(amount);
                  amountCtrl.text = '';
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
