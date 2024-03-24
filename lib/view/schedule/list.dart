// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';

import '../../view_model/schedule_view_model.dart';
import 'create.dart';

// ignore: camel_case_types
class scheduledScreen extends StatefulWidget {
  const scheduledScreen({super.key});

  @override
  State<scheduledScreen> createState() => _scheduledScreenState();
}

// ignore: camel_case_types
class _scheduledScreenState extends State<scheduledScreen> {
  final ScheduleViewModel _scheduledRepo = ScheduleViewModel();
  List listP = [];
  bool isData = false;

  Future<List> getSchedules() async {
    var res = await _scheduledRepo.fetchSchedules();
    if (res.isNotEmpty) {
      setState(() {
        listP = res;
        isData = true;
      });
    } else {
      setState(() {
        isData = false;
      });
    }
    return res;
  }

  @override
  void initState() {
    getSchedules();
    super.initState();
  }

  Future<void> _showDeleteConfirm(int sched) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar agenda'),
          content: const SingleChildScrollView(
            child: Text("Seguro deseas eliminar el registro?"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Si',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                await _scheduledRepo.deleteSchedule(sched);
                getSchedules();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            centerTitle: true,

            automaticallyImplyLeading: false,
            leadingWidth: 50, //this
            // this will hide Drawer hamburger icon
            title: const Text("Disponibilidad de Canchas"),
          )),
      body: isData
          ? ListView.builder(
              itemCount: listP.length,
              itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: ListTile(
                      // ignore: prefer_interpolation_to_compose_strings
                      title: Text(
                        listP[index].userSchedule,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        listP[index].dateSchedule,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          _showDeleteConfirm(listP[index].id);
                        },
                      ),
                      leading: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green,
                            boxShadow: const [
                              BoxShadow(color: Colors.green, spreadRadius: 3),
                            ],
                          ),
                          child: Text(
                            "Cancha " + listP[index].court,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                    ),
                  ))
          : const Center(child: Text('No hay registros de agenda')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: 'Add',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateSchedule()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
