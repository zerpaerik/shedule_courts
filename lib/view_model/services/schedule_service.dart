import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:schedule_courts/helpers/database.dart';
import 'package:schedule_courts/model/schedule.dart';

class ScheduleServices {
  Future<List<Schedule>> getSchedules() async {
    List<Schedule> schedules = [];
    try {
      List dataSchedules = await DBHelper.getScheduleAll();

      // ignore: avoid_function_literals_in_foreach_calls
      dataSchedules.forEach(
        (element) async {
          Schedule newSche = Schedule(
              court: element['court'],
              userSchedule: element['userSchedule'],
              dateSchedule: element['dateSchedule'],
              isActive: element['isActive'],
              id: element['id']);
          schedules.add(newSche);
        },
      );
      return schedules;
    } catch (e) {
      return schedules;
    }
  }

  Future<Map<String, dynamic>> getTempLocation() async {
    final response = await http.get(Uri.parse(
        "https://www.meteosource.com/api/v1/free/point?&lat=51.556028&lon=-0.2821926&sections=current&timezone=UTC&language=en&units=metric&key=r39mxvy7horj9qx5pxa8jxgi194elhiiyr3awsp3"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return jsonResponse;
  }
}
