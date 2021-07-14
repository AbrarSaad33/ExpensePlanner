import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'Transaction_Item.dart';
import '../models/Transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function _deleteTransactions;

  TransactionList(this.transactions, this._deleteTransactions);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraint) {
            return Column(
              children: [
                Text(
                  "No transactions added yet",
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                    height: constraint.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    )),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (context, index) {
              return TransactionItem(transactions: transactions[index], deleteTransactions: _deleteTransactions);
            },
            itemCount: transactions.length,
          );
  }
}

