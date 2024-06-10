import 'package:clockapp/clock_view.dart';
import 'package:clockapp/set_alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatedTime = DateFormat('HH:mm').format(now);
    var formatedDate = DateFormat('EEE , d MMM').format(now);
    var timezoneString = now.timeZoneOffset.toString().split('.').first;

    var offsetSign = '';

    if (!timezoneString.startsWith('-')) {
      offsetSign = '+';
    }
    print(timezoneString);

    return Scaffold(
        backgroundColor: const Color(0xFF2D2F41),
        body: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(54),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Clock',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    formatedTime,
                    style: const TextStyle(color: Colors.white, fontSize: 64),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    formatedDate,
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const ClockView(),
                  const SizedBox(
                    height: 58,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                           context , MaterialPageRoute(
                            builder: (context) => const SetAlarm())
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        
                          backgroundColor:
                              Color.fromARGB(206, 169, 187, 190),
                          side: const BorderSide(color: Color.fromARGB(0, 255, 255, 255), width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )),
                      child: const Text(
                        'Set Alarm',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(245, 0, 0, 0)),
                      )),
                  const SizedBox(
                    height: 75,
                  ),
                  const Text(
                    'Time Zone',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(children: <Widget>[
                    const Icon(
                      Icons.language,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'UTC' + offsetSign + timezoneString,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    )
                  ])
                ],
              ),
            ),
          ],
        ));
  }
}
