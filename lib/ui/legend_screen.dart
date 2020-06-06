import 'package:flutter/material.dart';
import 'package:manager/models/status.dart';
import 'package:manager/ui/app_drawer.dart';

class LegendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Codes Legend'),
      ),
      drawer: AppDrawer(),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: statusM.getColorCode(
                  StatusEnum.N,
                ),
                child: Text(statusM.getValue(
                  StatusEnum.N,
                )),
              ),
              title: Text('New Transaction'),
              subtitle: Text('New confirmed transaction to process'),
            ),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: statusM.getColorCode(
                  StatusEnum.CR,
                ),
                child: Text(statusM.getValue(
                  StatusEnum.CR,
                )),
              ),
              title: Text('Customer Remaining'),
              subtitle: Text('You have paid customer partially'),
            ),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: statusM.getColorCode(
                  StatusEnum.CP,
                ),
                child: Text(statusM.getValue(
                  StatusEnum.CP,
                )),
              ),
              title: Text('Customer Paid'),
              subtitle: Text('You have paid customer fully'),
            ),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: statusM.getColorCode(
                  StatusEnum.BR,
                ),
                child: Text(statusM.getValue(
                  StatusEnum.BR,
                )),
              ),
              title: Text('Box Remaining'),
              subtitle:
                  Text('You have received payment from a dealer partially'),
            ),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: statusM.getColorCode(
                  StatusEnum.BP,
                ),
                child: Text(statusM.getValue(
                  StatusEnum.BP,
                )),
              ),
              title: Text('Box Paid'),
              subtitle: Text('You have received payment from a dealer fully'),
            ),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: statusM.getColorCode(
                  StatusEnum.GP,
                ),
                child: Text(statusM.getValue(
                  StatusEnum.GP,
                )),
              ),
              title: Text('Gain Paid'),
              subtitle: Text(
                  'You have received your gain "commission" from a dealer'),
            ),
          ),
        ],
      ),
    );
  }
}
