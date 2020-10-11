import 'package:expense/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTranactions;

  Chart(this.recentTranactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalsum = 0.0;
      for (var i = 0; i < recentTranactions.length; i++) {
        if (recentTranactions[i].date.day == weekDay.day &&
            recentTranactions[i].date.month == weekDay.month &&
            recentTranactions[i].date.year == weekDay.year) {
          totalsum += recentTranactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalsum,
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(groupedTransactionValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: CharBar(
                  data['day'],
                  data['amount'],
                  maxSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / maxSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
