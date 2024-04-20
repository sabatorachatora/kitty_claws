import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kitty_claws/widgets/app_calendar.dart';
import 'package:kitty_claws/widgets/app_divider.dart';
import 'package:kitty_claws/widgets/app_header.dart';
import 'package:kitty_claws/widgets/calendar_back_button.dart';
import 'package:kitty_claws/widgets/calendar_forward_button.dart';
import 'package:kitty_claws/widgets/calendar_title.dart';
import 'package:kitty_claws/widgets/kitty_claw_time.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("ja_JP");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int kittyCrowTime = 7;
  int _counter = 0;
  DateTime focusedDay = DateTime.now();
  late SharedPreferences prefs;
  final dateFormatter = DateFormat("yyyy-MM-dd");

  final List<DateTime> crowCutDates = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((value){

      prefs = value;
      setState(() {
        kittyCrowTime = prefs.getInt("kittyCrowTime")??7;
        prefs.getStringList("crowCutDates")?.forEach((element) {
          crowCutDates.add(dateFormatter.parse(element));
        });

      });

    });
  }

  void save(){
    print("kittyCrowTime is ${kittyCrowTime}");
    prefs.setInt("kittyCrowTime", kittyCrowTime);
    final list = crowCutDates.map((e) => dateFormatter.format(e)).toList();
    prefs.setStringList("crowCutDates", list);
    print("list is ${list}");
  }

  /***
   * crowCutDatesの中で一番最近の日付を探してその日付＋７で表示
   */
  DateTime? getNextCutCrowDate(){

    if(crowCutDates.isEmpty){
      return null;
    }
    var max = crowCutDates[0];
    for (var i = 0; i < crowCutDates.length; i++) {
      if (crowCutDates[i].isAfter(max)) {
        max = crowCutDates[i];
      }
      print(crowCutDates[i]);
    }

    print("max = $max");

    return max.add(Duration(days:kittyCrowTime ));
  }


  @override
  Widget build(BuildContext context) {
    print("Buildが機能しました。" + focusedDay.toString());

    DateTime? nextCutCrowDate = getNextCutCrowDate();

    return Scaffold(
    /***floatingActionButton:ElevatedButton(      // 要修正
        onPressed: ()=>_showDialog(context),
        //tooltip: 'Increment',
        child: const Text('ボタン'),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
        ),
      ),***/

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                EdgeInsets.only(left: 15, top: 23, bottom: 32, right: 19),
                child: AppHeader(
                  month: focusedDay,
                  onTapForward: () {
                    print("onTapが機能");
                    setState(() {
                      focusedDay = DateTime(
                          focusedDay.year, focusedDay.month - 1, focusedDay.day);
                      print(focusedDay.toIso8601String());
                    });
                  },
                  onTapBack: () {
                    print("onTapが機能");
                    setState(() {
                      focusedDay = DateTime(
                          focusedDay.year, focusedDay.month + 1, focusedDay.day);
                      print(focusedDay.toIso8601String());
                    });
                  },
                ),
              ),
              AppDivider(),
              AppCalendar(
                focusedDay: focusedDay,
                crowCutDates: crowCutDates,
                kittyCrowTime: kittyCrowTime,
                nextCutCrowDate: nextCutCrowDate,
                onRemoveDay: ontapDay,
              ),
              AppDivider(),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: KittyClawTime(
                  kittyCrowTime: kittyCrowTime,
                  nextCutCrowDate: nextCutCrowDate,
                  onSelectedCrowTime: (selectedDay){
                    setState(() {
                      kittyCrowTime = selectedDay;
                      save();
                    });
                  },),
              ),
            ],
          ),
        ),
      ),



    floatingActionButton: FloatingActionButton(
        onPressed: ()=>_showDialog(context),
        tooltip: 'Increment',
        child: const Icon(Icons.edit_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  void _showDialog(BuildContext context)async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      print('選択された日付: ${picked.toString()}');
      setState(() {
        crowCutDates.add(picked);
        save();
      });
    }
  }

  void ontapDay(DateTime day){
    print("OntapDayがクリックされました。${day}");
    setState(() {
      int ret=crowCutDates.indexWhere((element) => element.year== day.year &&
          element.month== day.month && element.day== day.day);
      if(ret!= -1){

        crowCutDates.removeAt(ret);
        save();
      }

    });
  }

}
