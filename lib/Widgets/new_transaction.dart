import 'dart:io';
import './adaptive_flat_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleInput = TextEditingController();
  final priceInput = TextEditingController();
  var _selectedDate;

  void submitted() {
    final enteredTitle = titleInput.text;
    final enteredPrice = double.parse(priceInput.text);
    if (priceInput.text.isEmpty) {
      return;
    }

    if (enteredTitle.isEmpty || enteredPrice <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTransaction(enteredTitle, enteredPrice, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: titleInput,
                decoration: InputDecoration(
                  labelText: ('title'),
                ),
                onSubmitted: (_) => submitted,
              ),
              TextField(
                controller: priceInput,
                decoration: InputDecoration(
                  labelText: ('price'),
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitted(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen'
                            : 'Picked Date:${DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                    AdaptiveFlatButton(_presentDatePicker),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: submitted,
                child: Text('Add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button!.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}