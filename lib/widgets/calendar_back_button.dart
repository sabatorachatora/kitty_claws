import 'package:flutter/material.dart';

class CalendarBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  const CalendarBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 61,
        height: 35,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 197, 197, 197),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Image.asset('assets/images/forward.png'),
      ),
    );
  }

}