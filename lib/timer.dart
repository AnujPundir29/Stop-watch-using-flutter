import 'dart:async';
import 'package:time_watch/timermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountDownTimer {
  int shortBreak = 5;
  int longBreak = 20;
  double _radius = 1;
  bool _isActive = true;
  Timer timer;
  Duration _time, _fullTime;
  int work = 30;

  String returnTime(Duration t) {
    String minutes = (t.inMinutes < 10)
        ? '0' + t.inMinutes.toString()
        : t.inMinutes.toString();
    int numSeconds = t.inSeconds - (t.inMinutes * 60);
    String seconds =
        (numSeconds < 10) ? '0' + numSeconds.toString() : numSeconds.toString();

    String formattedTime = minutes + ":" + seconds;

    return formattedTime;
  }

  //In Flutter, you use async (without the * sign) for Futures(only one return) and async*(with the * sign) for Streams(any number of return).
  //When you mark a function async*, you are creating a generator function.

  Stream<TimerModel> stream() async* {
    //You use the yield* statement to deliver a result like a return and * is used to return a stream and for a single value no *.
    // Stream.perodic is a constructor generating the stream after a duration of 1 second in our case.
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      String time;
      if (this._isActive) {
        //if isActive is true then reduce the time by 1 sec.
        _time = _time - Duration(seconds: 1);
        //change the radius if the clock i.e, the remaining time.
        _radius = _time.inSeconds / _fullTime.inSeconds;
        if (_time.inSeconds <= 0) {
          _isActive = false;
        }
      }
      time = returnTime(_time); //gives you the time in format of like "30:39
      return TimerModel(time, _radius);
    });
  }

  void startBreak(bool isShort) {
    _radius = 1;
    _time = Duration(minutes: (isShort) ? shortBreak : longBreak, seconds: 0);
    _fullTime = _time;
  }

  void startTimer() {
    if (_time.inSeconds > 0) _isActive = true;
  }

  void stopTimer() {
    _isActive = false;
  }

  void startWork() async {
    await readSettings();
    _radius = 1;
    _time = Duration(minutes: work, seconds: 0);
    _fullTime = _time;
  }

  Future readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    work = prefs.getInt('workTime') == null ? 30 : prefs.getInt('workTime');
    shortBreak =
        prefs.getInt('shortBreak') == null ? 30 : prefs.getInt('shortBreak');
    longBreak =
        prefs.getInt('longBreak') == null ? 30 : prefs.getInt('longBreak');
  }
}
