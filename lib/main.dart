import 'package:expenses_app/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import './models/transaction.dart';
import './widgets/new_transaction_form.dart';
import './widgets/transaction_list.dart';

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
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.amber,
        textTheme: GoogleFonts.quicksandTextTheme(),
        appBarTheme: AppBarTheme(
          textTheme: GoogleFonts.quicksandTextTheme().copyWith(
            headline6: GoogleFonts.quicksand().copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 16.53,
      date: DateTime.now(),
    ),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where(
          (element) => element.date.isAfter(
            DateTime.now().subtract(
              Duration(days: 7),
            ),
          ),
        )
        .toList();
  }

  void _addNewTransaction(String title, double amount, DateTime choosenDate) {
    final newTx = Transaction(
      id: DateTime.now().millisecond.toString(),
      title: title,
      amount: amount,
      date: choosenDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _bottomSheetAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransactionForm(onSave: _addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Expenses'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chart(recentTransactions: _recentTransactions),
            TransactionList(
              transactions: _userTransactions,
              deleteTransaction: _deleteTransaction,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _bottomSheetAddNewTransaction(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
