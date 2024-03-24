import 'package:flutter/cupertino.dart';
import 'package:schedule_courts/view_model/services/schedule_service.dart';

import '../helpers/database.dart';
import '../model/schedule.dart';

class ScheduleViewModel with ChangeNotifier {
  List<Schedule> _schedules = [];

  List<Schedule> get sched => _schedules;

  /// Call the media service and gets the data of requested media data of
  /// an artist.
  Future<List> fetchSchedules() async {
    _schedules = await ScheduleServices().getSchedules();
    return _schedules;
  }

  Future<void> saveSchedule(data) async {
    Schedule newSchedule = Schedule(
        id: 0,
        court: data['court'],
        userSchedule: data['userSchedule'],
        dateSchedule: data['dateSchedule'],
        isActive: 1);
    _schedules.add(newSchedule);
    await DBHelper.insertSchedule(newSchedule);
    notifyListeners();
  }

  Future<int> deleteSchedule(data) async {
    // _schedules.remove(data);
    await DBHelper.deleteSchedule(data);
    return 1;
  }

  Future<Map<String, dynamic>> getTempLocation() async {
    final response = await ScheduleServices().getTempLocation();
    return response;
  }
}
