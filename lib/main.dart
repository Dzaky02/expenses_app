import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import './widgets/user_transactions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // For importing locale code
    // See https://github.com/dart-lang/intl/blob/master/lib/date_symbol_data_local.dart
    // for the detail
    initializeDateFormatting();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Container(
                child: Text('CHART!'),
              ),
              elevation: 5,
            ),
            UserTransactions(),
          ],
        ),
      ),
    );
  }
}
