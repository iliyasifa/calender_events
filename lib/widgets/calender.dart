import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({Key? key}) : super(key: key);

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  List<Appointment> selectedEvents = [];
  DateFormat customDateFormat = DateFormat('yyyy-MM-dd');
  DateTime selectedDay =
      DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
  final GlobalKey<FormState> keyGlobal = GlobalKey<FormState>();
  String? selectedWasteType;
  var isRecyclable = false;
  FocusNode submitFocusNode = FocusNode();

  List<String> wasteCategory = [
    'Recyclables Waste',
    'General Waste',
  ];

  List<String> houseNo = [
    '01',
    '02',
  ];

  List<Appointment> getEventsFromDay() {
    return selectedEvents
        .where((element) => element.startTime == selectedDay)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Calender Events'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Column(
          children: [
            Form(
              child: DropdownButtonFormField(
                hint: const Text('choose house no.'),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                items: houseNo
                    .map(
                      (no) => DropdownMenuItem(
                        value: no,
                        child: Text(no),
                      ),
                    )
                    .toList(),
                onChanged: (value) {},
              ),
            ),
            Expanded(
              child: SfCalendar(
                todayHighlightColor: Theme.of(context).primaryColor,
                selectionDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.deepOrange,
                    width: 2,
                  ),
                ),
                onTap: (details) {
                  setState(() {
                    selectedDay =
                        customDateFormat.parse(details.date.toString());
                  });
                },
                view: CalendarView.month,
                initialDisplayDate: DateTime.now(),
                initialSelectedDate: DateTime.now(),
                cellBorderColor: Colors.transparent,
                backgroundColor: Colors.white,
                todayTextStyle: const TextStyle(color: Colors.black),
                viewHeaderStyle: const ViewHeaderStyle(
                  backgroundColor: Colors.white,
                  dayTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerStyle: const CalendarHeaderStyle(
                  textAlign: TextAlign.center,
                ),
                monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                  appointmentDisplayCount: 10,
                ),
                dataSource: EventDataSource(selectedEvents),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ...getEventsFromDay().map(
                    (event) => Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.recycling_outlined,
                            color: event.color,
                          ),
                          title: Text(
                            event.subject,
                            style: TextStyle(
                              fontSize: 18,
                              color: event.color,
                            ),
                          ),
                          subtitle: const Text('12:30 PM'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            title: const Text('Add Event'),
            content: Container(
              constraints: const BoxConstraints(
                maxHeight: 50,
              ),
              child: Form(
                key: keyGlobal,
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      hint: const Text('Choose type of waste'),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      items: wasteCategory
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedWasteType = value.toString();
                          if (selectedWasteType == 'Recyclables Waste') {
                            isRecyclable = true;
                          } else {
                            isRecyclable = false;
                          }
                        });
                      },
                      onTap: () {
                        FocusScope.of(context).requestFocus(submitFocusNode);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'cancel',
                  style: TextStyle(
                    color: Colors.deepOrangeAccent,
                  ),
                ),
              ),
              TextButton(
                focusNode: submitFocusNode,
                onPressed: () => submit(selectedDay),
                child: const Text(
                  'ok',
                  style: TextStyle(
                    color: Colors.deepOrangeAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
        label: const Text('add Event'),
        icon: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void submit(DateTime date) {
    if (selectedWasteType!.isEmpty) {
      return;
    } else {
      selectedEvents.add(
        Appointment(
          startTime: date,
          endTime: date,
          subject: selectedWasteType.toString(),
          isAllDay: true,
          color: isRecyclable ? Colors.deepOrangeAccent : Colors.green,
        ),
      );
    }

    setState(() {});
    Navigator.pop(context);
    return;
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> source) {
    appointments = source;
  }
}
