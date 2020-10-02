import 'package:flutter/material.dart';
import 'package:time_watch/timer.dart';
import 'widgets.dart';
import 'settings.dart';
import 'package:time_watch/timermodel.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final double defaultPadding = 5.0; //sets a default padding

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.blueGrey,
      debugShowCheckedModeBanner: false,
      home: TimerHomePage(),
    );
  }
}

class TimerHomePage extends StatelessWidget {
  final CountDownTimer timer = CountDownTimer();
  final double defaultPadding = 5.0;

  @override
  Widget build(BuildContext context) {
    //a PopupMenuButton displays a menu when pressed. In its itemBuilder property, it can show a List of PopupMenuItems.
    final List<PopupMenuItem<String>> menuItems = List<PopupMenuItem<String>>();
    menuItems.add(
      PopupMenuItem(
        child: Text("Settings"),
        value: "Settings",
      ),
    );
    timer.startWork();

    //Navigation in Flutter is based on a stack. A stack contains the screens that an app has built from the beginning of its execution.
    //MaterialPageRoute class, in which you specify the name of the page you want to push. Both push() and pop() require the current context.
    void goToSettings(BuildContext context) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SettingsScreen()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("My Work Timer"),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) {
              return menuItems.toList();
            },
            onSelected: (s) {
              if (s == 'Settings') goToSettings(context);
            },
          )
        ],
        // actionsIconTheme: Icon(Icons.more_vert),
      ),

      ///        Isolate has a own memory and line of code.

      ///The waiter was taking orders (main Isolate),
      /// the cook could prepare the dishes. The time of
      ///  preparation does not change (it always takes 25 minutes),
      /// but the main execution line is always responding to the user
      /// requests, because long-running operations are executed in secondary Isolates.

      ///LayoutBuilder in its builder method; we'll
      ///find the available width by calling the maxWidth
      /// property of the BoxContraints instance that was
      /// passed to the method and put it into an availableWidth constant

      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth;
          return Column(
            children: [
              Row(
                children: [
                  //These are the first three buttons .
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                    child: ProductivityButton(
                      color: Colors.green[400],
                      onPressed: () => timer.startWork(),
                      text: "Work",
                      // size: 20,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(defaultPadding)),
                  Expanded(
                    child: ProductivityButton(
                      color: Colors.grey[500],
                      onPressed: () => timer.startBreak(true),
                      text: "Short Break",
                      // size: 20,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(defaultPadding)),
                  Expanded(
                    child: ProductivityButton(
                      color: Colors.black45,
                      onPressed: () => timer.startBreak(false),
                      text: "Long Break",
                      // size: 10,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(defaultPadding)),
                ],
              ),

              // This is the middle widget using the circular percent indicator

              Expanded(
                //A StreamBuilder rebuilds its children at any change in the Stream.
                //An AsyncSnapshot contains the data of the most recentinteraction with a StreamBuilder
                //The data shown is received from the yield* in the stream() method of the CountDownTimer class, which returned a TimerModel object
                child: StreamBuilder<Object>(
                    initialData: '00:00',
                    stream: timer.stream(),
                    builder: (context, snapshot) {
                      TimerModel timer = (snapshot.data == '00:00')
                          ? TimerModel('00:00', 1)
                          : snapshot.data;
                      return CircularPercentIndicator(
                        radius: availableWidth / 1.2,
                        lineWidth: 16,
                        percent: timer.percent,
                        center: Text(
                          timer.time,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        progressColor: Colors.lightBlue,
                      );
                    }),
              ),

              //These are the last two buttons .

              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                      child: ProductivityButton(
                    color: Colors.black87,
                    text: "Stop",
                    onPressed: () => timer.stopTimer(),
                  )),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                    child: ProductivityButton(
                      color: Colors.green,
                      text: "Start",
                      onPressed: () => timer.startTimer(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
