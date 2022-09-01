import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarSample extends StatefulWidget {
  const CalendarSample({Key? key}) : super(key: key);

  @override
  State<CalendarSample> createState() => CalendarSampleState();
}

class CalendarSampleState extends State<CalendarSample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Peel Waste Pickup Calendar"),
          backgroundColor: const Color(0xFF84C879),
          shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50))),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SfCalendar(
            headerStyle: const CalendarHeaderStyle(
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            view: CalendarView.month,
            firstDayOfWeek: 7,
            monthViewSettings: const MonthViewSettings(
              showAgenda: true,
              agendaItemHeight: 50,
              agendaStyle: AgendaStyle(
                appointmentTextStyle: TextStyle(),
              ),
            ),
            dataSource: MeetingDataSource(getAppointments()),
          ),
        ));
  }
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];

  meetings.add(Appointment(
      startTime: DateTime(2022, 1, 4),
      endTime: DateTime(2022, 1, 4),
      subject: 'Recycling Collection',
      color: Colors.blue,
      recurrenceRule: 'FREQ=DAILY;INTERVAL=14;COUNT=30',
      recurrenceExceptionDates: <DateTime>[
        DateTime(2022, 2, 22),
        DateTime(2022, 5, 24),
        DateTime(2022, 8, 2),
        DateTime(2022, 10, 11),
      ],
      isAllDay: true));

  meetings.add(Appointment(
      startTime: DateTime(2022, 1, 4),
      endTime: DateTime(2022, 1, 4),
      subject: 'Organics Collection',
      color: Colors.green,
      recurrenceRule: 'FREQ=DAILY;INTERVAL=7;COUNT=54',
      recurrenceExceptionDates: <DateTime>[
        DateTime(2022, 2, 22),
        DateTime(2022, 5, 24),
        DateTime(2022, 8, 2),
        DateTime(2022, 9, 6),
        DateTime(2022, 10, 11),
        DateTime(2022, 12, 27),
      ],
      isAllDay: true));

  meetings.add(Appointment(
      startTime: DateTime(2022, 1, 11),
      endTime: DateTime(2022, 1, 11),
      subject: 'Garbage Collection',
      color: Colors.black,
      recurrenceRule: 'FREQ=DAILY;INTERVAL=14;COUNT=30',
      recurrenceExceptionDates: <DateTime>[
        DateTime(2022, 2, 22),
        DateTime(2022, 9, 6),
        DateTime(2022, 12, 27),
      ],
      isAllDay: true));

  //Yard Waste 1
  meetings.add(Appointment(
      startTime: DateTime(2022, 3, 8),
      endTime: DateTime(2022, 3, 8),
      subject: 'Yard Waste Collection',
      color: Colors.brown,
      recurrenceRule: 'FREQ=DAILY;INTERVAL=7;COUNT=20',
      recurrenceExceptionDates: <DateTime>[
        DateTime(2022, 5, 24),
        DateTime(2022, 6, 28),
        DateTime(2022, 12, 27),
      ],
      isAllDay: true));
  //Yard Waste 2
  meetings.add(Appointment(
      startTime: DateTime(2022, 8, 16),
      endTime: DateTime(2022, 8, 16),
      subject: 'Yard Waste Collection',
      color: Colors.brown,
      recurrenceRule: 'FREQ=DAILY;INTERVAL=14;COUNT=4',
      isAllDay: true));
  //Yard Waste 3
  meetings.add(Appointment(
      startTime: DateTime(2022, 10, 4),
      endTime: DateTime(2022, 10, 4),
      subject: 'Yard Waste Collection',
      color: Colors.brown,
      recurrenceRule: 'FREQ=DAILY;INTERVAL=7;COUNT=10',
      recurrenceExceptionDates: <DateTime>[
        DateTime(2022, 10, 11),
      ],
      isAllDay: true));
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
