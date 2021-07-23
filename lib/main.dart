import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import './models/transaction.dart';
import './widgets/chart.dart';
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
  // helper variable
  var _showChart = false;

  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 69.99,
      date: DateTime.now().subtract(Duration(days: 6)),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 16.53,
      date: DateTime.now().subtract(Duration(days: 6)),
    ),
    Transaction(
      id: 't3',
      title: 'T-shirt',
      amount: 30.6,
      date: DateTime.now().subtract(Duration(days: 5)),
    ),
    Transaction(
      id: 't4',
      title: 'New Books',
      amount: 40.3,
      date: DateTime.now().subtract(Duration(days: 5)),
    ),
    Transaction(
      id: 't5',
      title: 'New Boots',
      amount: 89.49,
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
    Transaction(
      id: 't6',
      title: 'Gym',
      amount: 24.6,
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
    Transaction(
      id: 't8',
      title: 'Laundry',
      amount: 40.53,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: 't7',
      title: 'Catering Meal Plan',
      amount: 109.99,
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double statusBar = MediaQuery.of(context).padding.top;
    final isIOS = Platform.isIOS;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Widgets
    //   App Bar
    final PreferredSizeWidget appBar = isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  onPressed: () => _bottomSheetAddNewTransaction(context),
                  child: const Icon(CupertinoIcons.add),
                )
              ],
            ),
          )
        : AppBar(
            title: const Text('Personal Expenses'),
            actions: [
              if (isLandscape)
                IconButton(
                  onPressed: () => _bottomSheetAddNewTransaction(context),
                  icon: const Icon(Icons.add),
                )
            ],
          ) as PreferredSizeWidget;
    //  transaction listview
    final transListView = TransactionList(
      transactions: _userTransactions,
      deleteTransaction: _deleteTransaction,
    );
    //  chart view
    Widget chartView(double heightPercentage) {
      return Container(
        height: (size.height - appBar.preferredSize.height - statusBar) *
            heightPercentage,
        child: Chart(recentTransactions: _recentTransactions),
      );
    }

    // page body
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLandscape)
              ..._buildLandscapeContent(
                chartView(0.8),
                transListView,
              ),
            if (!isLandscape) ...[
              chartView(0.3),
              transListView,
            ],
          ],
        ),
      ),
    );

    return isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Visibility(
              visible: (!isLandscape && !isIOS),
              child: FloatingActionButton(
                onPressed: () => _bottomSheetAddNewTransaction(context),
                child: const Icon(Icons.add),
              ),
            ),
          );
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

  List<Widget> _buildLandscapeContent(Widget chartView, Widget transListView) =>
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Show Chart',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Switch.adaptive(
              value: _showChart,
              onChanged: (value) {
                setState(() {
                  _showChart = value;
                });
              },
              activeColor: Theme.of(context).accentColor,
            ),
          ],
        ),
        _showChart ? chartView : transListView
      ];
}
