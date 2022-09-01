import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class EventData extends StatefulWidget {
  const EventData({Key? key}) : super(key: key);

  @override
  State<EventData> createState() => _EventDataState();
}

class _EventDataState extends State<EventData> {
  var mappp = {
    "house number": {"waste": "sat", "recycle": 'Mon'},
    "house 1number": {"waste": 'sat', "recycle": 'Mon'},
    "house n2umber": {"waste": 'sat', "recycle": 'Mon'}
  };

  List rawData = [];
  Map mappedData = {};
  Future<void> loadAsset() async {
    final myData =
        await rootBundle.loadString("assets/Operations Schedule to upload.csv");
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(myData);
    debugPrint("\n\nraw data $csvTable\n\n");
    rawData = csvTable;
    // for (var i = 1; i < rawData.length; i++) {
    //   var row = rawData[i];
    //   var houseData = {};

    //   houseData['House no.'] = row[0];
    //   houseData['Waste'] = row[1];
    //   houseData['Organic'] = row[2];
    //   houseData['Recycle'] = row[3];

    //   mappedData.add(houseData);
    // }

    rawData.map((e) {
      mappedData.addAll({
        e[0]: {
          'Waste': e[1],
          'Organic': e[2],
          'Recycle': e[3],
        }
      });
    });
    debugPrint("\n\nMap data $mappedData\n\n");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CSV"),
      ),
      body: ListView.builder(
        itemBuilder: ((context, index) {
          return ListTile(
            title: Text('House no: ${mappedData[index]['House no.']}'),
            subtitle: Text('Waste: ${mappedData[index]['Waste']}'),
          );
        }),
        itemCount: mappedData.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () async {
          await loadAsset();
        },
      ),
    );
  }
}
