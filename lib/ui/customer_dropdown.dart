import 'package:flutter/material.dart';
import 'package:manager/db/people.dart';
import 'package:manager/models/customer.dart';

typedef CustomerValue = int Function(int);

class CustomerDropdown extends StatefulWidget {
  final CustomerValue cb;
  CustomerDropdown({@required this.cb});

  @override
  _CustomerDropdownState createState() => _CustomerDropdownState();
}

class _CustomerDropdownState extends State<CustomerDropdown> {
  List<Customer> customers;
  String selected;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return customers != null
        ? DropdownButton<String>(
            isExpanded: true,
            hint: Text('Customers'),
            value: selected,
            items: customers.map((e) {
              return DropdownMenuItem<String>(
                value: e.id.toString(),
                child: new Text(e.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selected = value;
              });
              final int id = int.tryParse(value);
              widget.cb(id);
            },
          )
        : Container();
  }

  Future<void> loadData() async {
    customers = await peopleDb.getCustomers();
    if (mounted) {
      setState(() {
        customers = customers;
      });
    }
  }
}
