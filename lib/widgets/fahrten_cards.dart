import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class FahrtenCards extends StatefulWidget {
  final String category;
  final List<dynamic> data;

  const FahrtenCards({Key? key, required this.category, required this.data}) : super(key: key);

  @override
  _FahrtenCardsState createState() => _FahrtenCardsState();
}

class _FahrtenCardsState extends State<FahrtenCards> {

  // List<dynamic> widget.data = []; // To store the JSON data

  // bool isLoading = true;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   fetchData(); // Call the API when the widget is first created
  // }
  //
  // Future<void> fetchData() async {
  //   isLoading = true;
  //   // Make the API call and parse the JSON response
  //   final response = await http.get(Uri.parse('http://185.223.29.19:8080/fahrten'));
  //
  //   if (response.statusCode == 200) {
  //     isLoading = false;
  //     setState(() {
  //       final List<dynamic> allData = json.decode(response.body);
  //       final List<dynamic> categoryData = allData.where((item) => item['status'] == widget.category).toList();
  //       widget.data = categoryData;
  //     });
  //   } else {
  //     isLoading = false;
  //     throw Exception('Failed to load data from the API');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // return isLoading ? const Loading() : Center(
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // const SizedBox(height: 8.0),
          Expanded(
            child: widget.data.isEmpty ? const Center(child: Text("Aktuell gibt es hier nichts zu sehen!")) : ListView.builder(
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
                                        print(item['id']);
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
// TODO infinite loadingScreen on Android
// TODO change "Edit" button according to category -> category "expired" should just have an "information" button