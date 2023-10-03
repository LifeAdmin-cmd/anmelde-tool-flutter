import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/screens/loading.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_app_bar.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_drawer.dart';
import 'package:galaxias_anmeldetool/models/anmelde_provider.dart';
import 'package:galaxias_anmeldetool/widgets/fahrten_cards.dart';
import 'package:provider/provider.dart';

class FahrtenList extends StatefulWidget {
  final String category;
  final String title;
  final bool forceUpdate;
  const FahrtenList({super.key, required this.category, required this.title, this.forceUpdate = false});

  @override
  State<FahrtenList> createState() => _FahrtenListState();
}

class _FahrtenListState extends State<FahrtenList> {
  // TODO add correct category

  late List<dynamic> jsonData = []; // To store the JSON data

  // late Map<String, int> categoryCount;

  bool isLoading = true;

  late String nullText;

  void setNullText() {
    switch (widget.category) {
      case ('future'):
        nullText = "Es sind noch keine Fahrten für die Zukunft geplant";
      case ('expired'):
        nullText = "Es liegen noch keine Fahrten in der Vergangenheit";
      case ('pending'):
        nullText = "Du bist aktuell zu keiner Veranstaltung eingeladen";
    }
  }

  @override
  void initState() {
    super.initState();
    setNullText();

    Future.microtask(
        () => Provider.of<AnmeldeProvider>(context, listen: false).fetchData(forceUpdate: widget.forceUpdate));
  }

  // function to fetch data
  // Future<void> fetchData() async {
  //   // TODO update to production URL
  //   final response = await http.get(
  //       Uri.parse('https://api.larskra.eu/fahrten'));
  //
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       final List<dynamic> allData = json.decode(response.body);
  //       final List<dynamic> categoryData = allData.where((
  //           item) => item['status'] == widget.category).toList();
  //       categoryCount = countStatusValues(allData);
  //       jsonData = categoryData;
  //       isLoading = false; // Set isLoading to false when data is loaded
  //     });
  //   } else {
  //     // TODO add error screen
  //     isLoading = false;
  //     throw Exception('Failed to load data from the API');
  //   }
  // }

  // Function to count status values
  Map<String, int> countStatusValues(List<dynamic> data) {
    Map<String, int> counts = {};
    for (var item in data) {
      final status = item['status'] as String;
      counts[status] = (counts[status] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnmeldeProvider>(context);

    if (provider.testId.isEmpty) provider.initTestId();

    // Guard clauses for null values
    if (provider.categoryCount == null || provider.allData == null) {
      return const Scaffold(
        body: Loading(),
      );
    }

    return Scaffold(
      appBar: DPVAppBar(title: widget.title),
      drawer: provider.isLoading
          ? const Loading()
          : DPVDrawer(categoryCount: provider.categoryCount!),
      body: provider.isLoading
          ? const Loading()
          : RefreshIndicator(
              onRefresh: () async {
                await Provider.of<AnmeldeProvider>(context, listen: false)
                    .fetchData(forceUpdate: true);
              },
              child: FahrtenCards(
                category: widget.category,
                data: provider.allData!
                    .where((item) => item['status'] == widget.category)
                    .toList(),
                nullText: nullText,
                onRefresh: () {  // Here is where the fetchData is triggered
                  Provider.of<AnmeldeProvider>(context, listen: false)
                      .fetchData(forceUpdate: true);
                },
              )

      ),
    );
  }
}
// TODO Fahrten nach Datum sortieren
