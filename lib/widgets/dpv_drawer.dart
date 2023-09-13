import 'package:flutter/material.dart';

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
                Image.asset(
                  'lib/assets/DPV_Lilie.png',
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
            onTap: () {},
          ),
          ListTile(
            title: const Text("Zukünftige Fahrten"),
            onTap: () {},
          )
        ],
      ),
    );
  }
}