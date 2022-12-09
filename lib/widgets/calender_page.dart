import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({Key? key}) : super(key: key);

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  List<Appointment> eventsData = [];
  List<Map<String, dynamic>> fromCsvMapped = [];
  String? selectedValue;
  TextEditingController controller = TextEditingController();
  List<Appointment> appointmentDetails = <Appointment>[];

  @override
  void initState() {
    super.initState();
    loadAsset();
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      setState(() {
        appointmentDetails =
            calendarTapDetails.appointments!.cast<Appointment>();
        // calendarTapDetails.date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Calender Events'),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                hint: const Text('choose house no.'),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                value: selectedValue,
                items: fromCsvMapped
                    .map(
                      (houseNo) => DropdownMenuItem(
                        value: houseNo['House no.'],
                        child: Text(houseNo['House no.']),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      eventsData = [];
                      appointmentDetails = [];
                      selectedValue = value.toString();
                      allEvents(fromCsvMapped, selectedValue!);
                    }
                  });
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: SfCalendar(
                todayHighlightColor: Theme.of(context).primaryColor,
                selectionDecoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.deepOrange,
                    width: 2,
                  ),
                ),
                onTap: calendarTapped,
                initialDisplayDate: DateTime.now(),
                initialSelectedDate: DateTime.now(),
                cellBorderColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                todayTextStyle: const TextStyle(color: Colors.black),
                viewHeaderStyle: const ViewHeaderStyle(
                  backgroundColor: Colors.white,
                  dayTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerStyle:
                    const CalendarHeaderStyle(textAlign: TextAlign.center),
                // monthViewSettings: const MonthViewSettings(
                //   showAgenda: true,
                //   agendaItemHeight: 50,
                // ),
                view: CalendarView.month,
                dataSource: DataSource(eventsData),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(2),
                itemCount: appointmentDetails.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: appointmentDetails[index].color,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'on',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${appointmentDetails[index].startTime.day}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      title: Text(
                        appointmentDetails[index].subject,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Text(
                        '9:00 AM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  height: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadAsset() async {
    List rawDataFromCSV = [];

    final myData =
        await rootBundle.loadString("assets/Operations Schedule to upload.csv");
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(myData);

    rawDataFromCSV = csvTable;
    for (var i = 1; i < rawDataFromCSV.length; i++) {
      var row = rawDataFromCSV[i];
      Map<String, dynamic> houseData = {};

      houseData['House no.'] = row[0];
      houseData['Waste'] = row[1];
      houseData['Organic'] = row[2];
      houseData['Recycle'] = row[3];

      fromCsvMapped.add(houseData);
    }

    selectedValue = 'I-501 M';
    allEvents(fromCsvMapped, selectedValue!);
    setState(() {});
  }

  void allEvents(List<Map<String, dynamic>> data, String houseNo) {
    for (var e in data) {
      if (e['House no.'] == houseNo) {
        String wasteDay = e['Waste']!;
        String organicDay = e['Organic']!;
        String recycleDay = e['Recycle']!;

        addEvents(wasteDay.trim(), 'Waste');
        addEvents(organicDay.trim(), 'Organic');
        addEvents(recycleDay.trim(), 'Recycle');
      }
    }
  }

  void addEvents(String parameter, String type) {
    if (parameter == 'Daily') {
      allAppointmentsAdd(parameter.toUpperCase(), type);
    } else if (parameter.contains(',')) {
      List<String> concatilateList = [];
      for (var element in parameter.split(',')) {
        concatilateList.add(element.trim().toUpperCase().substring(0, 2));
      }
      String concValue = concatilateList.join(',');
      allAppointmentsAdd(concValue, type);
    } else {
      allAppointmentsAdd(parameter.trim().toUpperCase().substring(0, 2), type);
    }
  }

  void allAppointmentsAdd(String freq, String type) {
    if (freq == 'DAILY') {
      eventsData.add(
        Appointment(
          startTime: DateTime.now(),
          endTime: DateTime.now().add(
            const Duration(hours: 2),
          ),
          subject: type,
          isAllDay: true,
          color: getColor(type),
          recurrenceRule: 'FREQ=$freq',
        ),
      );
    } else {
      eventsData.add(
        Appointment(
          startTime: DateTime.now(),
          endTime: DateTime.now().add(
            const Duration(hours: 2),
          ),
          isAllDay: true,
          color: getColor(type),
          subject: type,
          recurrenceRule: 'FREQ=WEEKLY;BYDAY=$freq',
        ),
      );
    }
  }

  Color getColor(String type) {
    if (type == 'Waste') {
      return Colors.red;
    } else if (type == 'Organic') {
      return Colors.green;
    } else if (type == 'Recycle') {
      return Colors.blue;
    }
    return Colors.black;
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}
