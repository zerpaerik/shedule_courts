import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_courts/helpers/database.dart';

import '../../helpers/custom_exception.dart';
import '../../view_model/schedule_view_model.dart';
import '../base/custom_text_form_field.dart';
import 'list.dart';

class CreateSchedule extends StatefulWidget {
  const CreateSchedule({super.key});

  @override
  State<CreateSchedule> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CreateSchedule> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController courtController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final ScheduleViewModel _scheduleRepository = ScheduleViewModel();

  String selectedCourt = "A";
  String tempCourt = "";

  @override
  void dispose() {
    super.dispose();
    courtController.dispose();
    userController.dispose();
    dateController.dispose();
  }

  Future<void> _showCourtFull() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancha OCUPADA'),
          content: SingleChildScrollView(
            child: Text(
                "La cancha $selectedCourt ya posee más de tres actividades agendadas para el dia ${dateController.text}"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Ok',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                dateController.text = "";
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  onTapFunction({required BuildContext context}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      lastDate: DateTime.now(),
      firstDate: DateTime(2015),
      initialDate: DateTime.now(),
    );
    if (pickedDate == null) return;
    dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    Map<String, dynamic> getData = {
      "court": selectedCourt,
      "dateSchedule": dateController.text
    };
    //r39mxvy7horj9qx5pxa8jxgi194elhiiyr3awsp3
    //api key tiempo de lluvia
    int disp = await DBHelper.query(getData);
    if (disp > 2) {
      _showCourtFull();
    } else {
      var temp = await ScheduleViewModel().getTempLocation();

      if (temp['current']['precipitation']['type'] == "none") {
        setState(() {
          tempCourt = "Sin pronóstico de lluvia";
        });
      } else {
        tempCourt = "Habrá precipitaciones ${temp['precipitation']['total']}";
      }
    }
  }

  Future<void> validateData() async {
    if (_formKey.currentState!.validate()) {
      process();
    }
  }

  process() async {
    // ignore: nullable_type_in_catch_clause
    try {
      Map<String, dynamic> data = {
        "court": selectedCourt,
        "userSchedule": userController.text,
        "dateSchedule": dateController.text,
      };

      // ignore: unused_local_variable
      var res = await _scheduleRepository.saveSchedule(data);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const scheduledScreen()),
      );
      // ignore: unused_catch_clause
    } on CustomException catch (e) {
      Future.delayed(Duration.zero, () {
        // Widgets.hideLoder(context);
        // HelperUtils.showSnackBarMessage(context, e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: AppBar(
              leading: const BackButton(
                color: Colors.black,
              ),
              leadingWidth: 50, //this
              // this will hide Drawer hamburger icon
              title: const Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text('Creación de agenda'),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              centerTitle: true,
            )),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField(
                  context,
                  title: "¿Cuál es el usuario que desea reservar?",
                  controller: userController,
                  validator: CustomTextFieldValidator.nullCheck,
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: const Text('¿Cuál es la cancha que deseas reservar?',
                        style: TextStyle(fontSize: 17))),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    // padding: const EdgeInsets.all(7.0),
                    child: DropdownButton<String>(
                      value: selectedCourt,
                      dropdownColor: Colors.white,
                      underline: const SizedBox.shrink(),
                      items: const [
                        DropdownMenuItem(
                          value: "A",
                          child: Text(
                            "Cancha A",
                          ),
                        ),
                        DropdownMenuItem(
                          value: "B",
                          child: Text("Cancha B"),
                        ),
                        DropdownMenuItem(
                          value: "C",
                          child: Text("Cancha C"),
                        ),
                      ],
                      onChanged: (value) {
                        selectedCourt = value ?? "";
                        setState(() {});
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: const Text(
                      '¿Qué dia deseas reservar?',
                      style: TextStyle(fontSize: 17),
                    )),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                        hintText: "Presione para indicar la fecha"),
                    onTap: () => onTapFunction(context: context),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                if (dateController.text.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      tempCourt,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      validateData();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Guardar'),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

Widget buildTextField(BuildContext context,
    {required String title,
    required TextEditingController controller,
    CustomTextFieldValidator? validator,
    bool? readOnly}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: 5,
      ),
      Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Text(
            title,
            style: const TextStyle(fontSize: 17),
          )),
      const SizedBox(
        height: 5,
      ),
      Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        child: CustomTextFormField(
          controller: controller,
          isReadOnly: readOnly,
          validator: validator,
          keyboard: TextInputType.text,
          // formaters: [FilteringTextInputFormatter.deny(RegExp(","))],
          // fillColor: context.color.textLightColor.withOpacity(00.01),
        ),
      )
    ],
  );
}

Widget buildDateField(BuildContext context,
    {required String title,
    required TextEditingController controller,
    CustomTextFieldValidator? validator,
    bool? readOnly}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: 5,
      ),
      Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Text(title)),
      const SizedBox(
        height: 5,
      ),
      Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        child: CustomTextFormField(
          controller: controller,
          isReadOnly: readOnly,
          validator: validator,
          keyboard: TextInputType.datetime,
          // formaters: [FilteringTextInputFormatter.deny(RegExp(","))],
          // fillColor: context.color.textLightColor.withOpacity(00.01),
        ),
      )
    ],
  );
}
