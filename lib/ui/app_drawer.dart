import 'package:flutter/material.dart';
import 'package:manager/ui/box_screen.dart';
import 'package:manager/ui/customer_screen.dart';
import 'package:manager/ui/dealer_screen.dart';
import 'package:manager/ui/dealer_summary_screen.dart';
import 'package:manager/ui/legend_screen.dart';
import 'package:manager/ui/transaction_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
            icon: Icons.monetization_on,
            text: 'Transactions',
            onTap: () => Navigator.of(context).pushReplacement(
              _getRoute(
                context,
                TransactionScreen(),
              ),
            ),
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.people,
            text: 'Customers',
            onTap: () => Navigator.of(context).pushReplacement(
              _getRoute(
                context,
                CustomerScreen(),
              ),
            ),
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.verified_user,
            text: 'Dealers',
            onTap: () => Navigator.of(context).pushReplacement(
              _getRoute(
                context,
                DealerScreen(),
              ),
            ),
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.inbox,
            text: 'My Box',
            onTap: () => Navigator.of(context).pushReplacement(
              _getRoute(
                context,
                BoxScreen(),
              ),
            ),
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.color_lens,
            text: 'Legend',
            onTap: () => Navigator.of(context).pushReplacement(
              _getRoute(
                context,
                LegendScreen(),
              ),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(''),
            subtitle:
                Text('Designed & developed by Ihab Arnous copyright 2020'),
            onTap: null,
          )
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        backgroundBlendMode: BlendMode.color,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/drawer_header.png'),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text(
              "",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  MaterialPageRoute _getRoute(BuildContext context, Widget screen) {
    return MaterialPageRoute(
      builder: (context) => screen,
    );
  }
}
