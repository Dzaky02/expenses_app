import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.transactions,
    required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transactions;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
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
                '\$ ${transactions.amount.toStringAsFixed(2)}',
              ),
            ),
          ),
        ),
        title: Text(
          transactions.title,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          DateFormat('EEEE, dd MMMM y', 'in').format(
            transactions.date.toLocal(),
          ),
          style: Theme.of(context).textTheme.caption,
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? TextButton.icon(
          onPressed: () => deleteTransaction(transactions.id),
          icon: const Icon(Icons.delete),
          label: const Text('delete'),
          style:
          TextButton.styleFrom(primary: Theme.of(context).errorColor),
        )
            : IconButton(
            onPressed: () => deleteTransaction(transactions.id),
            icon: const Icon(Icons.delete),
            color: Theme.of(context).errorColor),
      ),
    );
  }
}
