import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DPVDrawer extends StatelessWidget {
  final Map<String, int> categoryCount;

  const DPVDrawer({super.key, required this.categoryCount});

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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Aktive Anmeldephase"),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    child: Text(categoryCount['pending'] != null ? categoryCount['pending'].toString() : "0"),
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/");
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Vergangene Fahrten"),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    child: Text(categoryCount['expired'] != null ? categoryCount['expired'].toString() : "0"),
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/vergangeneFahrten");
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Zukünftige Fahrten"),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    child: Text(categoryCount[''] != null ? categoryCount[''].toString() : "0"), // TODO add correct category
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/futureFahrten");
            },
          )
        ],
      ),
    );
  }
}