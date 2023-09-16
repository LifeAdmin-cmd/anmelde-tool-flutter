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

  @override
  Widget build(BuildContext context) {
    DateTime eventStart = DateTime.parse(fahrtenData['startDate']);
    DateTime eventEnd = DateTime.parse(fahrtenData['endDate']);
    DateTime registrationStart =
        DateTime.parse(fahrtenData['registrationStart']);
    DateTime registrationEnd =
        DateTime.parse(fahrtenData['registrationDeadline']);

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
                            PhaseInfoWidget(
                              phase: 'Anmeldephase', 
                              date: registrationStart,
                              startOrEnde: 'Start',
                            ),
                            PhaseInfoWidget(
                              phase: 'Anmeldephase',
                              date: registrationEnd,
                              startOrEnde: 'Ende',
                            ),
                            PhaseInfoWidget(
                              phase: 'Veranstaltungstermin',
                              date: eventStart,
                              startOrEnde: 'Start',
                            ),
                            PhaseInfoWidget(
                              phase: 'Veranstaltungstermin',
                              date: eventEnd,
                              startOrEnde: 'Ende',
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

class PhaseInfoWidget extends StatelessWidget {
  final String phase;
  final DateTime date;
  final String startOrEnde;

  const PhaseInfoWidget({
    super.key,
    required this.phase,
    required this.date,
    required this.startOrEnde,
  });

  @override
  Widget build(BuildContext context) {
    Widget getIcon(DateTime date, String phase, String startOrEnde) {
      DateTime now = DateTime.now();
      bool anmeldephase = phase == 'Anmeldephase' ? true : false;
      bool start = startOrEnde == 'Start' ? true : false;

      if (now.isBefore(date)) {
        return RoundIcon(
          iconData: Icons.schedule_outlined,
          backgroundColor: Colors.amber.shade600,
        );
      } else if (now.isAfter(date) && anmeldephase && !start) {
          return RoundIcon(
            iconData: Icons.close,
            backgroundColor: Colors.grey.shade700,
          );
      } else if (now.isAfter(date)) {
        return const RoundIcon(
          iconData: Icons.check,
          backgroundColor: Colors.green,
        );
      }

      return RoundIcon(
        iconData: Icons.error_outline,
        backgroundColor: Colors.orange.shade700,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          Column(
            children: [
              getIcon(date, phase, startOrEnde),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      phase,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                        // TODO Times all at 16:00, look if it's wrong in the response data or the formatting
                        "$startOrEnde: ${DateFormat("d. MMM -").add_Hm().format(date)} Uhr "
                        "(${date.isBefore(DateTime.now()) ? "Vor" : "In"} ${date.difference(DateTime.now()).inDays.abs()} Tagen)"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RoundIcon extends StatelessWidget {
  final IconData iconData;
  final double iconSize;
  final Color iconColor;
  final double circleRadius;
  final Color backgroundColor;

  const RoundIcon({
    super.key,
    required this.iconData,
    this.iconSize = 20.0,
    this.iconColor = Colors.white,
    this.backgroundColor = const Color.fromRGBO(101, 220, 0, 1.0),
    this.circleRadius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: circleRadius,
        backgroundColor: backgroundColor,
        child: Icon(
          iconData,
          size: iconSize,
          color: iconColor,
        ),
      ),
    );
  }
}
