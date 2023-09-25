import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/screens/fahrten_ansicht.dart';
import 'package:intl/intl.dart';

class FahrtenCards extends StatefulWidget {
  final String category;
  final List<dynamic> data;
  final String nullText;
  final VoidCallback onRefresh; // Added this callback for refreshing data

  const FahrtenCards({
    Key? key,
    required this.category,
    required this.data,
    required this.nullText,
    required this.onRefresh, // Initialize the callback in constructor
  }) : super(key: key);

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
          widget.data.isEmpty
              ? Column(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 85,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        // show dynamic error text
                        widget.nullText,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: widget.onRefresh,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min, // This will make the Row as small as possible
                        children: [
                          Text("Aktualisieren"),
                          SizedBox(width: 8), // To provide a little space between the text and the icon
                          Icon(Icons.refresh),
                        ],
                      ),
                    ),

                  ],
                )
              : Expanded(
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
                                title: Text(item['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['shortDescription']),
                                    const SizedBox(
                                        height:
                                            20.0), // Add spacing between main content and dates
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "Von ${DateFormat('d.M.y').format(DateTime.parse(item['startDate']))} bis ${DateFormat('d.M.y').format(DateTime.parse(item['endDate']))}"),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Row(
                                      children: [
                                        /// Anmelde und Info Button (conditional)
                                        Expanded(
                                          // Wrap the button in an Expanded widget
                                          child: OutlinedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FahrtenAnsicht(
                                                          fahrtenData: item),
                                                ),
                                              );
                                            },
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  widget.category != "pending"
                                                      ? Colors.blue[800]
                                                      : Colors.green[700],
                                              foregroundColor: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center, // Center the content horizontally
                                              children: [
                                                Text(
                                                    widget.category != "pending"
                                                        ? "Ansehen"
                                                        : 'Anmelden'),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 0, 0),
                                                  child: Icon(
                                                    widget.category != "pending"
                                                        ? Icons.visibility
                                                        : Icons.edit,
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

// TODO change "Edit" button according to category -> category "expired" should just have an "information" button
