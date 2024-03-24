import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BasePage extends StatefulWidget {
  Widget body;
  Widget? appbar;

  BasePage({Key? key, required this.body, this.appbar}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _BasePageState createState() => _BasePageState(body, appbar);
}

class _BasePageState extends State<BasePage> {
  Widget body;
  Widget? appbar;
  late ScrollController controller;

  _BasePageState(this.body, this.appbar);
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(54.0),
          child: widget.appbar ??
              AppBar(
                automaticallyImplyLeading: false,
                leadingWidth: 50, //this
                // this will hide Drawer hamburger icon
                title: Container(
                    width: 200,
                    height: 70,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(37),
                            bottomRight: Radius.circular(37))),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          'assets/image.png',
                          width: 160,
                          // height: 10,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    )),
                centerTitle: true,
              )),
      body: widget.body,
    );
  }
}
