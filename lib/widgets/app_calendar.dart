import 'package:flutter/material.dart';
import 'package:kitty_claws/widgets/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';
typedef OnRemoveDay= void Function(DateTime day);
typedef OnAddDay= void Function(DateTime day);

class AppCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final List<DateTime> crowCutDates;
  final int kittyCrowTime;
  final DateTime? nextCutCrowDate;
  final OnRemoveDay? onRemoveDay;
  final OnAddDay? onAddDay;
  AppCalendar({super.key, required this.focusedDay, required this.crowCutDates, this.nextCutCrowDate, required this.kittyCrowTime, this.onRemoveDay, this.onAddDay});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ja_JP',
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      rowHeight: 60,
      daysOfWeekHeight: 50,
      focusedDay: focusedDay,
      calendarStyle: CalendarStyle(
          tableBorder: TableBorder(
            verticalInside: BorderSide(color: Colors.black, width: 0.7),
            horizontalInside: BorderSide(color: Colors.black, width: 0.7),
          )),
      headerVisible: false,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return createDay(day);
        },
        todayBuilder: (context, day, focusedDay) {
          return createDay(day);
        },
        outsideBuilder: (context, day, focusedDay) {
          return createOtherDay(day);
        },
      ),
    );
  }

  /***
   * 爪を切った日のリストの中に引数で渡されたdayがあればTrueを返却
   */
  bool isSameDays(DateTime day){
    for(var ite = crowCutDates.iterator;ite.moveNext(); ){
      var currentDate = ite.current;
      if(isSameDay(currentDate, day)) return true;
    }
    return false;
  }

  bool isSameDay(DateTime a, DateTime b){
    if(a.year == b.year && a.month == b.month && a.day == b.day){
      return true;
    }
    return false;
  }


  Widget createDay(DateTime day) {
    Color holiday = AppColors.cellColor;
    if (day.weekday == 6) {
      holiday = AppColors.satColor;
    } else if (day.weekday == 7) {
      holiday = AppColors.sunColor;
    }

    bool doShowCatCrow = isSameDays(day);

    DateTime? next =  nextCutCrowDate;
    bool doShowNextCatCrow = next == null? false: next.year == day.year && next.month == day.month && next.day == day.day;

    bool doShowToday  = isSameDay(DateTime.now(), day);
    bool doShowOtherday = day.isBefore(DateTime.now());

    return Container(
      color: holiday,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(child: Text("${day.day}")),
          ),
          if (doShowCatCrow) Positioned(
              bottom: 5,
              child: SizedBox(
                  width: 32,
                  child: GestureDetector(
                    onTap: ()=>onRemoveDay?.call(day),
                      child: Image.asset("assets/images/icon_cat_paw.png")))
          ),
          if (doShowNextCatCrow) Positioned(
              bottom: 5,
              child: SizedBox(
                  width: 32,
                  child: Image.asset("assets/images/icon_cat_paw2.png"))
          ),
          if(doShowToday) Positioned(
            bottom: 22,
              child: SizedBox(
                  width: 16,
                  child: Image.asset("assets/images/icon_todays.png"))

          ),
          if(doShowOtherday) Positioned(
              bottom: 5,
              child: SizedBox(
                  width: 32,
                  child: GestureDetector(
                      onTap: ()=>onAddDay?.call(day) ))
          )

        ],
      ),
    );
  }



  Widget createOtherDay(DateTime day) {
    return Container(
      color: AppColors.otherColor,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(child: Text("${day.day}")),
          )
        ],
      ),
    );
  }
}
