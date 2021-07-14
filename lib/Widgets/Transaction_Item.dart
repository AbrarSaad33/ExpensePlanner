import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/Transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.transactions,
    required Function deleteTransactions,
  })  : _deleteTransactions = deleteTransactions,
        super(key: key);

  final Transaction transactions;
  final Function _deleteTransactions;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: FittedBox(child: Text('\$${transactions.price}')),
          ),
        ),
        title: Text(
          transactions.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transactions.date),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
                onPressed: () => _deleteTransactions(transactions.id),
                icon: Icon(Icons.delete),
                textColor: Theme.of(context).errorColor,
                label: Text('Delete'))
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => _deleteTransactions(transactions.id),
              ),
      ),
    );
  }
}
