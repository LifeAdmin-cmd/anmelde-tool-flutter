import 'package:flutter/material.dart';

class DPVAppBar extends StatelessWidget implements PreferredSizeWidget {

  const DPVAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(32, 86, 223, 1),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: const [
        Padding(
          padding: EdgeInsets.all(10),
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