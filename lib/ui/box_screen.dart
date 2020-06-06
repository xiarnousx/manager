import 'package:flutter/material.dart';
import 'package:manager/db/box.dart';
import 'package:manager/models/the_box.dart';
import 'package:manager/ui/app_drawer.dart';
import 'package:manager/ui/box_dialog.dart';
import 'package:manager/ui/floating_button.dart';
import 'package:manager/util/formatter.dart';

class BoxScreen extends StatefulWidget {
  @override
  _BoxScreenState createState() => _BoxScreenState();
}

class _BoxScreenState extends State<BoxScreen> {
  final dialog = BoxDialog();
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  TheBox box;

  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('My Box'),
      ),
      drawer: AppDrawer(),
      body: box != null
          ? SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text('L'),
                      ),
                      title: Text('Box Limit'),
                      subtitle: Text(
                        '\$' +
                            Formatter.formatMoney(box.upper_limit_amount) +
                            ' K',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Text('OUT'),
                      ),
                      title: Text('Box Out'),
                      subtitle: Text(
                        '\$' +
                            Formatter.formatMoney(box.upper_limit_amount -
                                box.current_amount_remaining) +
                            ' K',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Text('IN'),
                      ),
                      title: Text('Box In'),
                      subtitle: Text(
                        '\$' +
                            Formatter.formatMoney(
                                box.current_amount_remaining) +
                            ' K',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(),
      floatingActionButton: FloatingButton.get(context, dialog, _globalKey),
    );
  }

  Future loadData() async {
    box = await boxDb.get();
    if (mounted) {
      setState(() {
        box = box;
      });
    }
  }
}
