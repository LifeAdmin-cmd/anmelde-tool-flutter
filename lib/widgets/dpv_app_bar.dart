import 'package:flutter/material.dart';

class DPVAppBar extends StatelessWidget implements PreferredSizeWidget {

  const DPVAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(child: Text(title, style: const TextStyle(color: Colors.white),)),
      backgroundColor: const Color.fromRGBO(32, 86, 223, 1),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: const <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
          child: Image(
            image: AssetImage('lib/assets/DPV_Lilie.png'),
          ),
        ),
      ]
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}