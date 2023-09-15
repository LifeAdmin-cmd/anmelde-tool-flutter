import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_app_bar.dart';

class FahrtenAnsicht extends StatefulWidget {
  final Map<String, dynamic> fahrtenData;

  const FahrtenAnsicht({super.key, required this.fahrtenData});

  @override
  State<FahrtenAnsicht> createState() => _FahrtenAnsichtState();
}

class _FahrtenAnsichtState extends State<FahrtenAnsicht> {
  Map<String, dynamic> get fahrtenData => widget.fahrtenData;

  Widget getIcon() {
    // TODO add logic to determine if X or Check Icon should be applied
    return const CheckIcon();
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate = DateTime.parse(fahrtenData['startDate']);

    return Scaffold(
      appBar: const DPVAppBar(title: 'Anmeldung'),
      body: SingleChildScrollView(
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Column(
                children: [
                  // Termine Card
                  Card(
                    margin: const EdgeInsets.fromLTRB(8, 15, 8, 15),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Termine',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              // TODO refactor so it can be reused for all 4 phases
                              children: [
                                const Column(
                                  children: [
                                    CheckIcon(),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Anmeldephase",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // TODO Times all at 16:00, look if it's wrong in the response data or the formatting
                                      Text("Start: ${DateFormat("d. MMM -").add_Hm().format(startDate)} Uhr "
                                          "(${startDate.isBefore(DateTime.now()) ? "Vor" : "In"} ${startDate.difference(DateTime.now()).inDays  .abs()} Tagen)"
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const SizedBox(width: 16),
            // TODO make ActionButton only visible when editing is possible
            FloatingActionButton.extended(
              onPressed: () {
                // TODO Anmelde-Prozess starten
              },
              label: const Text(
                'Anmelden',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(
                Icons.edit,
                size: 18,
                color: Colors.white,
              ),
              backgroundColor: Colors.green[600],
            ),
          ],
        ),
      ),
    );
  }
}

class CheckIcon extends StatelessWidget {
  final IconData iconData;
  final double iconSize;
  final Color iconColor;
  final double circleRadius;

  const CheckIcon({super.key,
    this.iconData = Icons.check,
    this.iconSize = 20.0,
    this.iconColor = Colors.white,
    this.circleRadius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: circleRadius,
        backgroundColor: const Color.fromRGBO(101, 220, 0, 1.0),
        child: Icon(
          iconData,
          size: iconSize,
          color: iconColor,
        ),
      ),
    );
  }
}

class XIcon extends StatelessWidget {
  final IconData iconData;
  final double iconSize;
  final Color iconColor;
  final double circleRadius;

  const XIcon({super.key,
    this.iconData = Icons.close,
    this.iconSize = 25.0,
    this.iconColor = Colors.white,
    this.circleRadius = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: circleRadius,
        backgroundColor: Colors.lightGreenAccent[700],
        child: Icon(
          iconData,
          size: iconSize,
          color: iconColor,
        ),
      ),
    );
  }
}
