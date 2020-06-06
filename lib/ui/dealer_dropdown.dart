import 'package:flutter/material.dart';
import 'package:manager/db/people.dart';
import 'package:manager/models/customer.dart';
import 'package:manager/models/dealer.dart';

typedef DealerValue = int Function(int);

class DealerDropdown extends StatefulWidget {
  final DealerValue cb;
  DealerDropdown({@required this.cb});

  @override
  _DealerDropdownState createState() => _DealerDropdownState();
}

class _DealerDropdownState extends State<DealerDropdown> {
  List<Dealer> dealers;
  String selected;

  @override
  Widget build(BuildContext context) {
    loadData();
    return dealers != null
        ? DropdownButton<String>(
            isExpanded: true,
            hint: Text('Dealers'),
            value: selected,
            items: dealers.map((e) {
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
    dealers = await peopleDb.getDealers();
    if (mounted) {
      setState(() {
        dealers = dealers;
      });
    }
  }
}
