import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location;
  String time = '';
  String flag;
  String latitude;
  String longitude;
  bool isDayTime = false;

  final apiKey = 'J0IJAYO4CHS1';

  WorldTime(
      {required this.location,
      required this.flag,
      required this.latitude,
      required this.longitude});

  Future<void> getTime() async {
    try {
      final response = await http.get(Uri.parse(
          'http://api.timezonedb.com/v2.1/get-time-zone?key=$apiKey&format=json&by=position&lat=$latitude&lng=$longitude'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        //get properties from data
        String formatted = data['formatted'];
        String dst = data['dst'];
        print(dst);

        //create DateTime object
        DateTime now = DateTime.parse(formatted);
        now = now.add(Duration(hours: int.parse(dst)));

        //set time property
        isDayTime = now.hour > 6 && now.hour < 20 ? true : false;
        time = DateFormat.jm().format(now);
      } else {
        print('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      print('caught error: $e');
      time = 'could not get time data';
    }
  }
}
