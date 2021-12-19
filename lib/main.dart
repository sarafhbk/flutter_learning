import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'widgets/chart.dart';
import 'widgets/transaction_list.dart';
import 'models/transaction.dart';
import 'widgets/new_transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'Quicksand',
          errorColor: Colors.red,
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              button: TextStyle(color: Colors.white)),
          appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];

  List<Transaction> get _recentTransactions {
    return _transactions
        .where(
            (tx) => tx.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  void _addTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: txDate);

    setState(() {
      _transactions.add(newTx);
    });
  }

  void _deleteTransaction(String txId) {
    setState(() {
      _transactions.removeWhere((element) => element.id == txId);
    });
  }

  void _startAddTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return NewTransaction(addTransaction: _addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Flutter App'),
      actions: [
        IconButton(
            onPressed: () => _startAddTransaction(context),
            icon: Icon(Icons.add))
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          Container(
            child: Switch.adaptive(
              value: true,
              onChanged: (val) {},
            ),
          ),
          Container(
              child: Chart(_recentTransactions),
              height: MediaQuery.of(context).size.height * 0.4 -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top),
          Container(
            child: TransactionList(
                userTransactions: _transactions,
                deleteTransaction: _deleteTransaction),
            height: MediaQuery.of(context).size.height * 0.6 -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? null
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddTransaction(context),
            ),
    );
  }
}
