import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DPVDrawer extends StatelessWidget {

  const DPVDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color.fromRGBO(32, 86, 223, 1)),
            child: Column(
              children: <Widget>[
                SvgPicture.asset(
                  'lib/assets/DPV_Lilie.svg',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 8.0),
                const Text(
                  "Anmelde-Tool",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text("Aktive Anmeldephase"),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/home");
            },
          ),
          ListTile(
            title: const Text("Vergangene Fahrten"),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/vergangeneFahrten");
            },
          ),
          ListTile(
            title: const Text("Zukünftige Fahrten"),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/futureFahrten");
            },
          )
        ],
      ),
    );
  }
}