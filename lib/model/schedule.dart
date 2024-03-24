class Schedule {
  final int id;
  final String court;
  final String userSchedule;
  final int isActive;
  final String dateSchedule;

  const Schedule(
      {required this.id,
      required this.court,
      required this.userSchedule,
      required this.isActive,
      required this.dateSchedule});
}
