import 'package:flutter/material.dart';

typedef OnSelectedCrowTime = void Function(int selectedDay);

class KittyClawTime extends StatelessWidget{
  final int kittyCrowTime;
  final DateTime? nextCutCrowDate;
  final OnSelectedCrowTime? onSelectedCrowTime;
  const KittyClawTime({super.key, required this.kittyCrowTime, this.nextCutCrowDate, this.onSelectedCrowTime});

  @override
  Widget build(BuildContext context) {

    int nextDay = 0;
    if(nextCutCrowDate!=null){
      Duration days = DateTime.now().difference(nextCutCrowDate!);
      nextDay = days.inDays;
    }

    return GestureDetector(
      onTap: ()async{
        //print("Tap _");
        String? text = await _showNumberInputDialog(context);
        int selectedDayTimes = int.tryParse(text!) ?? 0;
        onSelectedCrowTime?.call(selectedDayTimes);
      },
      child: Column(
        children: [
          Text('現在の爪きりの間隔は${kittyCrowTime}日です。', style: TextStyle(fontSize: 24),),
          Text('次の爪切りは${nextDay}日後です', style: TextStyle(fontSize: 24),),
        ],
      ),
    );
  }

  Future<String?> _showNumberInputDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();


    return showDialog<String>(

      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('爪切りの間隔の設定'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                ),
              ),
              Text('日', style: TextStyle(fontSize: 24),),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // キャンセルボタンが押されたらダイアログを閉じる
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final text = controller.value.text;
                if (int.tryParse(text) != null) {
                  final intValue = int.parse(text);
                  if (intValue < 0) {
                    // マイナスの場合は符号を反転させる
                    final reversedValue = (-1) * intValue;
                    Navigator.of(context).pop(reversedValue.toString());
                  } else {
                    Navigator.of(context).pop(text);
                  }
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}