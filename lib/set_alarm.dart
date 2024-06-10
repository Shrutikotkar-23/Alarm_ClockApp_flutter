// import 'dart:html';

import 'package:clockapp/models/alarm_helper.dart';
import 'package:clockapp/models/alarm_info.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

// import 'package:clockapp/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:clockapp/main.dart';

class SetAlarm extends StatefulWidget {
  const SetAlarm({super.key});

  @override
  State<SetAlarm> createState() {
    return _SetAlarmState();
  }
}

class _SetAlarmState extends State<SetAlarm> {
  bool switchValue = true;

  DateTime? _alarmTime;
  late String _alarmTimeString;
  bool _isRepeatSelected = false;
  final AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>>? _alarms;
  List<AlarmInfo>? _currentAlarms;

  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      print('------database intialized');
      loadAlarms();
    });
    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool switchstate = true;
    return Material(
        color: const Color(0xFF2D2F41),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Alarm',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'avenir',
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<AlarmInfo>>(
                    future: _alarms,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _currentAlarms = snapshot.data;
                        return ListView(
                          children: snapshot.data!.map<Widget>((alarm) {
                            var alarmTime = DateFormat('hh:mm aa')
                                .format(alarm.alarmDateTime!);
                            return Container(
                              height: 150,
                              margin: const EdgeInsets.only(bottom: 24),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 18),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 103, 169, 190),
                                      Color.fromARGB(255, 205, 110, 181)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(143, 19, 67, 96),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                    offset: Offset(2, 2),
                                  )
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24)),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.label,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            alarm.title!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'avenir',
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      CupertinoSwitch(
                                        value : switchstate,
                                      onChanged: (bool value) {
                                        setState(() {
                                          switchstate = value;
                                        });
                                        print(value);
                                      },
                                      
                                        trackColor: const Color.fromARGB(
                                            126, 255, 255, 255),
                                        activeColor: const Color.fromARGB(
                                            160, 69, 151, 240),
                                             
                                        
                                          // This is called when the user toggles the switch.
                                          
                                        
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    'Mon-Fri',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'avenir',
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        alarmTime,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'avenir',
                                        ),
                                      ),
                                      IconButton(
                                          icon: const Icon(Icons.delete),
                                          color: Colors.white,
                                          onPressed: () {
                                            deleteAlarm(alarm.id);
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).followedBy([
                            if (_currentAlarms!.length < 5)
                              Container(
                                height: 150,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 42, 73, 97),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24)),
                                ),
                                child: MaterialButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  onPressed: () {
                                    _alarmTimeString = DateFormat('HH:mm')
                                        .format(DateTime.now());
                                    showModalBottomSheet(
                                      useRootNavigator: true,
                                      context: context,
                                      clipBehavior: Clip.antiAlias,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(24),
                                        ),
                                      ),
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setModalState) {
                                            return Container(
                                              padding: const EdgeInsets.all(32),
                                              child: Column(
                                                children: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      var selectedTime =
                                                          await showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      );
                                                      if (selectedTime !=
                                                          null) {
                                                        final now =
                                                            DateTime.now();
                                                        var selectedDateTime =
                                                            DateTime(
                                                                now.year,
                                                                now.month,
                                                                now.day,
                                                                selectedTime
                                                                    .hour,
                                                                selectedTime
                                                                    .minute);
                                                        _alarmTime =
                                                            selectedDateTime;
                                                        setModalState(() {
                                                          _alarmTimeString =
                                                              DateFormat(
                                                                      'HH:mm')
                                                                  .format(
                                                                      selectedDateTime);
                                                        });
                                                      }
                                                    },
                                                    child: Text(
                                                      _alarmTimeString,
                                                      style: const TextStyle(
                                                          fontSize: 32),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    title: const Text('Repeat'),
                                                    trailing: Switch(
                                                      onChanged: (value) {
                                                        setModalState(() {
                                                          _isRepeatSelected =
                                                              value;
                                                        });
                                                      },
                                                      value: _isRepeatSelected,
                                                    ),
                                                  ),
                                                  const ListTile(
                                                    title: Text('Sound'),
                                                    trailing: Icon(Icons
                                                        .arrow_forward_ios),
                                                  ),
                                                  const ListTile(
                                                    
                                                    title: Text('Title'),
                                                    trailing: Icon(Icons
                                                        .arrow_forward_ios),
                                                  ),
                                                  FloatingActionButton.extended(
                                                    onPressed: () {
                                                      onSaveAlarm(
                                                          _isRepeatSelected);
                                                    },
                                                    icon:
                                                        const Icon(Icons.alarm),
                                                    label: const Text('Save'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Image.asset(
                                        'img/plus_icon2.png',
                                        height: 75,
                                        width: 75,
                                        scale: 1.5,
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Add Alarm',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              const Center(
                                  child: Text(
                                'Only 5 alarms allowed!',
                                style: TextStyle(color: Colors.white),
                              )),
                          ]).toList(),
                        );
                      }
                      return const Center(
                        child: Text(
                          'Loading..',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )));
  }

  void scheduleAlarm(
      DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo,
      {required bool isRepeating}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      channelDescription: 'Channel for Alarm notification',
      icon: 'clock_logo',
      sound: RawResourceAndroidNotificationSound('alarm_sound'),
      largeIcon: DrawableResourceAndroidBitmap('clock_logo'),
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // if (isRepeating) {
    //   await flutterLocalNotificationsPlugin.showDailyAtTime(
    //     0,
    //     'Office',
    //     alarmInfo.title,
    //     Time(
    //       scheduledNotificationDateTime.hour,
    //       scheduledNotificationDateTime.minute,
    //       scheduledNotificationDateTime.second,
    //     ),
    //     platformChannelSpecifics,
    //   );
    // } else {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Office',
        alarmInfo.title,
        tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    // }
  }

  void onSaveAlarm(bool _isRepeating) {
    DateTime? scheduleAlarmDateTime;
    if (_alarmTime!.isAfter(DateTime.now())) {
      scheduleAlarmDateTime = _alarmTime;
    } else {
      scheduleAlarmDateTime = _alarmTime!.add(const Duration(days: 1));
    }

    var alarmInfo = AlarmInfo(
      alarmDateTime: scheduleAlarmDateTime,
      title: 'alarm',
    );
    _alarmHelper.insertAlarm(alarmInfo);
    if (scheduleAlarmDateTime != null) {
      scheduleAlarm(scheduleAlarmDateTime, alarmInfo,
          isRepeating: _isRepeating);
    }
    Navigator.pop(context);
    loadAlarms();
  }

  void deleteAlarm(int? id) {
    _alarmHelper.delete(id);
    //unsubscribe for notification
    loadAlarms();
  }
}
