import 'package:flutter/material.dart';
import 'package:manager/db/people.dart';
import 'package:manager/models/customer.dart';
import 'package:manager/models/dealer.dart';
import 'package:manager/ui/app_drawer.dart';
import 'package:manager/ui/customer_dialog.dart';
import 'package:manager/ui/dealer_dialog.dart';
import 'package:manager/ui/dealer_summary_screen.dart';
import 'package:manager/ui/floating_button.dart';

class DealerScreen extends StatefulWidget {
  @override
  _DealerScreenState createState() => _DealerScreenState();
}

class _DealerScreenState extends State<DealerScreen> {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  DealerDialog dialog = DealerDialog();
  List<Dealer> dealers;
  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Manage Dealers'),
      ),
      drawer: AppDrawer(),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: (dealers != null) ? dealers.length : 0,
        itemBuilder: (BuildContext context, int index) {
          final Dealer dealer = dealers[index];
          return Dismissible(
            background: Container(
              color: Colors.red,
            ),
            key: Key(dealer.id.toString()),
            onDismissed: (direction) {
              peopleDb.deleteDealer(dealer.id);
              setState(() {
                dealers.removeAt(index);
              });
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("${dealer.name} deleted"),
                  duration: Duration(
                    seconds: 1,
                  ),
                ),
              );
            },
            child: ListTile(
              title: Text(dealer.name),
              leading: CircleAvatar(
                child: Text(dealer.name.substring(0, 1).toUpperCase()),
              ),
              onTap: () {
                final route = MaterialPageRoute(
                  builder: (context) => DealerSummaryScreen(
                    dealer: dealer,
                  ),
                );
                Navigator.of(context).push(route);
              },
              trailing: null,
            ),
          );
        },
      ),
      floatingActionButton: FloatingButton.get(context, dialog, _globalKey),
    );
  }

  Future loadData() async {
    dealers = await peopleDb.getDealers();
    if (mounted) {
      setState(() {
        dealers = dealers;
      });
    }
  }
}
