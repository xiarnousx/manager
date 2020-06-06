import 'package:flutter/material.dart';
import 'package:manager/db/people.dart';
import 'package:manager/models/customer.dart';
import 'package:manager/ui/dialog_base.dart';

class CustomerDialog extends DialogBase {
  final nameCtrl = TextEditingController();

  Widget buildAlert(BuildContext context, GlobalKey<ScaffoldState> state) {
    return AlertDialog(
      title: Text('New Customer'),
      elevation: 2,
      content: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  hintText: 'Customer Name',
                ),
                keyboardType: TextInputType.text,
              ),
              RaisedButton(
                child: Text(
                  'Save Customer',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.green,
                onPressed: () async {
                  final String name = nameCtrl.text;

                  if (name == '') {
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

                  final int customerId = await peopleDb.insertCustomer(Customer(
                    name: name,
                  ));
                  nameCtrl.text = '';
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
