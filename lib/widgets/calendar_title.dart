import 'package:flutter/material.dart';

class CalendarTitle extends StatelessWidget {
  final DateTime month;
  const CalendarTitle({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${month.year}年'),
        Text('${month.month}月'),
      ],
    );
  }

}