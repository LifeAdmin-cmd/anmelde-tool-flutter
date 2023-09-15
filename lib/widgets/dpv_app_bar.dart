import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DPVAppBar extends StatelessWidget implements PreferredSizeWidget {

  const DPVAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(child: Text(title, style: const TextStyle(color: Colors.white),)),
      backgroundColor: const Color.fromRGBO(32, 86, 223, 1),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset('lib/assets/DPV_Lilie.svg', height: 50, width: 50,),
        ),
      ]
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}