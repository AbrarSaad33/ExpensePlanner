import 'dart:io';
import 'package:flutter/material.dart';
import './Widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import './models/Transaction.dart';
import 'Widgets/new_transaction.dart';
import './Widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          //errorColor: Colors.red,
          fontFamily: "Quicksand",
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                    fontFamily: "OpenSans",
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(fontFamily: "OpenSans", fontSize: 20)))),
      debugShowCheckedModeBanner: false,
      title: 'Personal Expense',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [];

  // [
  //   Transaction(
  //       id: 't1', title: 'New Shoes', price: 66.99, date: DateTime.now()),
  //   Transaction(
  //       id: 't1',
  //       title: 'Weekly Groceries',
  //       price: 66.99,
  //       date: DateTime.now()),
  // ];
  List<Transaction> get _recentTransaction {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  bool _showChart = false;

  void _addTransaction(String title, double price, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        price: price,
        date: chosenDate);
    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: ctx,
        isScrollControlled: true,
        builder: (_) {
          return GestureDetector(
            child: NewTransaction(_addTransaction),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere(
        (tx) => tx.id == id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appbar=AppBar(
        title: Text("Personal Expense"),
        actions: [
          IconButton(
              onPressed: () => startAddNewTransaction(context),
              icon: Icon(Icons.add))
        ],
      );
  

    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appbar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransaction, _deleteTransaction));
    final body = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Show Chart",
                  style: Theme.of(context).textTheme.title,
                ),
                Switch.adaptive(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    })
              ],
            ),
          if (!isLandscape)
            Container(
              height: (mediaQuery.size.height -
                      appbar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.3,
              child: Chart(_recentTransaction),
            ),
          if (!isLandscape) txListWidget,
          if (isLandscape)
            _showChart
                ? Container(
                    height: (mediaQuery.size.height -
                            appbar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.7,
                    child: Chart(_recentTransaction),
                  )
                : txListWidget,
        ],
      ),
    ));
    
      return Scaffold(
        appBar: appbar,
        body: body,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Platform.isIOS
            ? Container()
            : FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => startAddNewTransaction(context),
              ),
      );
    }
  }
