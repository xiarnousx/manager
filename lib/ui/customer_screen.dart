import 'package:flutter/material.dart';
import 'package:manager/db/people.dart';
import 'package:manager/models/customer.dart';
import 'package:manager/ui/app_drawer.dart';
import 'package:manager/ui/customer_dialog.dart';
import 'package:manager/ui/floating_button.dart';

class CustomerScreen extends StatefulWidget {
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  CustomerDialog dialog = CustomerDialog();
  List<Customer> customers;
  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Manage Customers'),
      ),
      drawer: AppDrawer(),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: (customers != null) ? customers.length : 0,
        itemBuilder: (BuildContext context, int index) {
          final Customer customer = customers[index];
          return Dismissible(
            background: Container(
              color: Colors.red,
            ),
            key: Key(customer.id.toString()),
            onDismissed: (direction) {
              peopleDb.deleteCustomer(customer.id);
              setState(() {
                customers.removeAt(index);
              });
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("${customer.name} deleted"),
                  duration: Duration(
                    seconds: 1,
                  ),
                ),
              );
            },
            child: ListTile(
              title: Text(customer.name),
              leading: CircleAvatar(
                child: Text(customer.name.substring(0, 1).toUpperCase()),
              ),
              onTap: null,
              trailing: null,
            ),
          );
        },
      ),
      floatingActionButton: FloatingButton.get(context, dialog, _globalKey),
    );
  }

  Future loadData() async {
    customers = await peopleDb.getCustomers();
    if (mounted) {
      setState(() {
        customers = customers;
      });
    }
  }
}
