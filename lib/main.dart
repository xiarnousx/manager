import 'package:flutter/material.dart';
import 'package:manager/db/connection.dart';
import 'package:manager/ui/transaction_screen.dart';

void main()  {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manager App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TransactionScreen(),
    );
  }
}
