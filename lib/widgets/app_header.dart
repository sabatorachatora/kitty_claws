import 'package:flutter/material.dart';

import 'calendar_back_button.dart';
import 'calendar_forward_button.dart';
import 'calendar_title.dart';

class AppHeader extends StatelessWidget{
  final VoidCallback? onTapForward;
  final VoidCallback? onTapBack;
  final DateTime month;
  const AppHeader({super.key, this.onTapForward, this.onTapBack, required this.month});

  @override
  Widget build(BuildContext context) {

    return Row(

      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        CalendarForwardButton(onTap: onTapForward,),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image.asset('assets/images/leftline.png'),
            Padding(
              padding: EdgeInsets.only(left: 11.58, right: 5),
              child: CalendarTitle(month: month,),
            ),
            Image.asset('assets/images/rightline.png'),
          ],),
        ),

        CalendarBackButton(onTap: onTapBack)

      ],
    );

  }

}