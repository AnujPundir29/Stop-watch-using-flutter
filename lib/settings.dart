import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:time_watch/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Settings(),
    );
  }
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // @override
  TextEditingController txtWork, txtShort, txtLong;

  // These are used to interact with the shared_preferances(i.e, a key value pair)
  static const String WORKTIME = "workTime",
      SHORTBREAK = "shortBreak",
      LONGBREAK = "longBreak";

  SharedPreferences prefs;
  int workTime, shortBreak, longBreak;

  @override
  void initState() {
    // we are creating the objects that will allow us to read from and write to the TextFieldwidgets.
    txtWork = TextEditingController();
    txtLong = TextEditingController();
    txtShort = TextEditingController();
    readSettings();
    super.initState();
  }

  // Read from shared_preferences

  // Asynchronous operations return Future objects (futures),
  // which is something tobe completed at a later time.
  // To suspend execution until a Future completes, weuse await in an async function.
  //In short, this function reads the values of the settings from SharedPreferences,and then it writes the values in the textFields.
  readSettings() async {
    prefs = await SharedPreferences.getInstance();
    int workTime = prefs.getInt(WORKTIME);
    if (workTime == null) {
      await prefs.setInt(WORKTIME, int.parse('30'));
    }
    int shortBreak = prefs.getInt(SHORTBREAK);
    if (shortBreak == null) {
      await prefs.setInt(SHORTBREAK, int.parse('5'));
    }
    int longBreak = prefs.getInt(LONGBREAK);
    if (longBreak == null) {
      await prefs.setInt(LONGBREAK, int.parse('20'));
    }

    setState(() {
      txtWork.text = workTime.toString();
      txtShort.text = shortBreak.toString();
      txtLong.text = longBreak.toString();
    });
  }

  // Write to shared_preferences

  // the value here is the + and - sign
  updateSettings(String key, int value) {
    switch (key) {
      case "WORKTIME":
        {
          int workTime = prefs.getInt(WORKTIME);
          workTime += value;
          if (workTime >= 1 && workTime <= 180) {
            // The code updates the key that was passed and also updates the text property of the textcontroller,
            prefs.setInt(WORKTIME, workTime);
            setState(() {
              txtWork.text = workTime.toString();
            });
          }
        }
        break;
      case "SHORTBREAK":
        {
          int shortBreak = prefs.getInt(SHORTBREAK);
          shortBreak += value;
          if (shortBreak >= 1 && shortBreak <= 120) {
            prefs.setInt(SHORTBREAK, shortBreak);

            setState(() {
              txtShort.text = shortBreak.toString();
            });
          }
        }
        break;
      case "LONGBREAK":
        {
          int longBreak = prefs.getInt(LONGBREAK);
          longBreak += value;
          if (longBreak >= 1 && longBreak <= 180) {
            prefs.setInt(LONGBREAK, longBreak);
            txtLong.text = longBreak.toString();
          }
        }
        break;
    }
  }

  TextStyle textStyle = TextStyle(fontSize: 24);
  Widget build(BuildContext context) {
    //The GridView is scrollable, and has two dimensions: in otherwords, it's a scrollable table(horizantally / vertical).
    //GridView.Count() constructor can be used when you know the number of items that the grid will be shown on the screen.
    return Container(
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 3, //number of items that will appear on each row.

        //size of the children in the GridView.Here the width must be three times the height.
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10, // Add space b/w the children of the gridview .
        children: [
          Text("Work", style: textStyle),
          Text(""),
          Text(""),
          SettingButton(Color(0xff455A64), "-", -1, WORKTIME, updateSettings),
          TextField(
            textAlign: TextAlign.center,
            style: textStyle,
            keyboardType: TextInputType.number,
            controller: txtWork,
          ),
          SettingButton(Color(0xff455A64), "+", 1, WORKTIME, updateSettings),
          Text("Short", style: textStyle),
          Text(""),
          Text(""),
          SettingButton(Color(0xff455A64), "-", -1, SHORTBREAK, updateSettings),
          TextField(
            textAlign: TextAlign.center,
            style: textStyle,
            keyboardType: TextInputType.number,
            controller: txtShort,
          ),
          SettingButton(Color(0xff455A64), "+", 1, SHORTBREAK, updateSettings),
          Text("Long", style: textStyle),
          Text(""),
          Text(""),
          SettingButton(Color(0xff455A64), "-", -1, LONGBREAK, updateSettings),
          TextField(
            textAlign: TextAlign.center,
            style: textStyle,
            keyboardType: TextInputType.number,
            controller: txtLong,
          ),
          SettingButton(Color(0xff455A64), "+", 1, LONGBREAK, updateSettings),
        ],
        padding: EdgeInsets.all(20),
      ),
    );
  }
}
