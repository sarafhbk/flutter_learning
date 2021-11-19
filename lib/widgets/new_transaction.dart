import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function(String, double, DateTime) addTransaction;
  NewTransaction({required this.addTransaction});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  dynamic _selectedDate;

  void submitData() {
    if (titleController.text.isEmpty ||
        double.parse(amountController.text) <= 0) {
      return;
    }
    widget.addTransaction(titleController.text,
        double.parse(amountController.text), _selectedDate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Text(_selectedDate == null
                      ? 'No Date Chosen!'
                      : 'Selected date: ${DateFormat.yMd().format(_selectedDate)}'),
                  TextButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now())
                            .then((value) => {
                                  if (value != null)
                                    {
                                      setState(() {
                                        _selectedDate = value;
                                      })
                                    }
                                });
                      },
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              ElevatedButton(
                  onPressed: submitData,
                  child: Text('Add Transaction',
                      style: TextStyle(
                        color: Colors.white,
                      )))
            ])
          ],
        ),
      ),
    );
  }
}
