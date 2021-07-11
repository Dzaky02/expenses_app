import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewTransactionForm extends StatelessWidget {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  final Function onSave;

  NewTransactionForm({required this.onSave});

  void submitData() {
    final enteredTitle = titleController.text;
    final amountTemp = amountController.text;

    if (enteredTitle.isEmpty || amountTemp.isEmpty) return;

    final enteredAmount = double.parse(amountTemp);

    if (enteredAmount <= 0) return;

    onSave(
      enteredTitle,
      enteredAmount,
    );
  }

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
              onFieldSubmitted: (_) => submitData(),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onFieldSubmitted: (_) => submitData(),
            ),
            TextButton(
              onPressed: submitData,
              child: Text('Add Transaction'),
              style: TextButton.styleFrom(primary: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}
