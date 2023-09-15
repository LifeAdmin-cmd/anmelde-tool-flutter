import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/screens/fahrten_ansicht.dart';
import 'package:intl/intl.dart';


class FahrtenCards extends StatefulWidget {
  final String category;
  final List<dynamic> data;

  const FahrtenCards({Key? key, required this.category, required this.data}) : super(key: key);

  @override
  _FahrtenCardsState createState() => _FahrtenCardsState();
}

class _FahrtenCardsState extends State<FahrtenCards> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget.data.isEmpty ? const Column(
            children: [
              Icon(Icons.warning_amber_rounded, size: 85,),
              SizedBox(height: 8.0,),
              Text(
                "Du bist aktuell zu keiner Veranstaltung eingeladen",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ) : Expanded(
            child: ListView.builder(
              itemCount: widget.data.length,
              itemBuilder: (BuildContext context, int index) {
                final item = widget.data[index];
                // Create a tile for each object in the JSON data
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.grey[200],
                    child: Column(
                      children: [
                        ListTile(
                          // trailing: const Icon(Icons.edit),
                          title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['shortDescription']),
                              const SizedBox(height: 20.0), // Add spacing between main content and dates
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Von ${DateFormat('d.M.y').format(DateTime.parse(item['startDate'] ))} bis ${DateFormat('d.M.y').format(DateTime.parse(item['endDate']))}"),
                                ],
                              ),
                              // const Divider(
                              //   height: 15.0,
                              // ),
                              const SizedBox(height: 15.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded( // Wrap the button in an Expanded widget
                                    child: OutlinedButton(
                                      onPressed: () {
                                        // TODO add info page template for Fahrten
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => FahrtenAnsicht(fahrtenData: item),
                                          ),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.green[700],
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center, // Center the content horizontally
                                        children: [
                                          Text('Anmelden'),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                            child: Icon(
                                              Icons.edit,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}

// TODO handle asynchronous suspension error -> after clicking through pages quickly
// TODO infinite loadingScreen on Android -> might be fixed
// TODO change "Edit" button according to category -> category "expired" should just have an "information" button