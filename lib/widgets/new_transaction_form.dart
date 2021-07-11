import 'package:flutter/material.dart';

class NewTransactionForm extends StatelessWidget {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  final Function onSave;

  NewTransactionForm({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
            ),
            TextButton(
              onPressed: () => onSave(
                titleController.text,
                double.parse(amountController.text),
              ),
              child: Text('Add Transaction'),
              style: TextButton.styleFrom(primary: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}
