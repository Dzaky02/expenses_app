import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  TransactionList(
      {required this.transactions, required this.deleteTransaction});

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No transaction added yet!',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (context, index) => Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 16,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Text(
                        '\$ ${transactions[index].amount.toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                ),
                title: Text(
                  transactions[index].title,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                subtitle: Text(
                  DateFormat('EEEE, dd MMMM y', 'in').format(
                    transactions[index].date.toLocal(),
                  ),
                  style: Theme.of(context).textTheme.caption,
                ),
                trailing: MediaQuery.of(context).size.width > 460
                    ? TextButton.icon(
                        onPressed: () =>
                            deleteTransaction(transactions[index].id),
                        icon: Icon(Icons.delete),
                        label: Text('delete'),
                        style: TextButton.styleFrom(
                            primary: Theme.of(context).errorColor),
                      )
                    : IconButton(
                        onPressed: () =>
                            deleteTransaction(transactions[index].id),
                        icon: Icon(Icons.delete),
                        color: Theme.of(context).errorColor),
              ),
            ),
          );
  }
}
