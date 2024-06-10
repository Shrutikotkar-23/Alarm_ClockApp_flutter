import 'package:clockapp/models/alarm_info.dart';

// List <AlarmInfo> alarms = [
//   AlarmInfo(DateTime.now().add(const Duration(hours :1)), title: 'College'),
//   AlarmInfo(DateTime.now().add(const Duration(hours :1)), title: 'class'),
// ];


List<AlarmInfo> alarms = [
  AlarmInfo(alarmDateTime: DateTime.now().add(const Duration(hours: 1)), title: 'Office'),
  AlarmInfo(alarmDateTime: DateTime.now().add(const Duration(hours: 2)), title: 'Sport'),
];