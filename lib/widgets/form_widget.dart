import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:galaxias_anmeldetool/widgets/personen_form.dart';
import 'package:galaxias_anmeldetool/widgets/module_builder.dart';

class FormWidget extends StatefulWidget {
  final dynamic modules;
  final dynamic genders;
  final dynamic eatingHabits;
  final List<dynamic> bookingOptions;
  final String fahrtenId;
  final List<Map<String, dynamic>> fetchedPersons;

  const FormWidget(
    {super.key,
    required this.modules,
    required this.genders,
    required this.eatingHabits,
    required this.fetchedPersons,
    required this.bookingOptions,
    required this.fahrtenId,
    }
  );

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  int _currentPosition = 0;

  Map<int, Map<String, dynamic>> pageData = {};

  late final int _totalPages;
  late final List<GlobalKey<FormBuilderState>> formKeys;

  @override
  void initState() {
    super.initState();
    _totalPages = widget.modules.length;
    formKeys = List.generate(
      _totalPages,
      (_) => GlobalKey<FormBuilderState>(),
    );
  }

  int _validPosition(int position) {
    if (position >= _totalPages) return 0;
    if (position < 0) return _totalPages - 1;
    return position;
  }

  void _updatePosition(int position) {
    setState(() => _currentPosition = _validPosition(position));
  }

  Widget _buildRow(
    List<Widget> widgets, {
    EdgeInsets padding = const EdgeInsets.only(bottom: 12.0),
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceAround,
  }) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: widgets,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> moduleData = widget.modules;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),

          // Navigation Dots
          _buildRow([
            // DotsIndicator for previous dots (grey color)
            _currentPosition > 0
                ? DotsIndicator(
                    dotsCount: _currentPosition,
                    position: _currentPosition - 1,
                    decorator: DotsDecorator(
                      size: const Size.square(20.0),
                      activeSize: const Size(20.0, 20.0),
                      color: Colors.blue
                          .shade200, // Set the default color for previous dots
                      activeColor: Colors
                          .blue.shade200, // Set the same color for previous dots
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the border radius as needed
                      ),
                      spacing: const EdgeInsets.all(
                          8.0), // Adjust the spacing between dots as needed
                    ),
                  )
                : Container(),

            // DotsIndicator for the active dot (blue color)
            DotsIndicator(
              dotsCount: _totalPages - _currentPosition,
              position: 0, // Start from the first dot
              decorator: DotsDecorator(
                size: const Size.square(20.0),
                activeSize: const Size(20.0, 20.0),
                color: Colors
                    .grey, // Set the default color for dots above the active page
                activeColor: Colors
                    .blue.shade600, // Set the active color for the current page
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the border radius as needed
                ),
                spacing: const EdgeInsets.all(
                    8.0), // Adjust the spacing between dots as needed
              ),
            ),
          ], mainAxisAlignment: MainAxisAlignment.center),

          // Horizontal Divider
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(),
          ),

          FormBuilder(
              key: formKeys[_currentPosition],
              initialValue: pageData[_currentPosition] ?? {},
              child: moduleData[_currentPosition]['title'] != "Personen"
                  ? ModuleBuilder(
                      module: moduleData[_currentPosition],
                      currentPageData:
                          pageData[_currentPosition] ?? {}, // <-- Add this line
                    )
                  : PersonenForm(
                      genders: widget.genders,
                      eatingHabits: widget.eatingHabits,
                      savedPersons: widget.fetchedPersons,
                      bookingOptions: widget.bookingOptions,
                      )),
          // const Padding(
          //   padding: EdgeInsets.all(12.0),
          //   child: Divider(),
          // ),

          // Navigation Buttons
          const SizedBox(
            height: 25,
          ),
          _buildRow([
            _currentPosition == 0
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Abbrechen',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _currentPosition == 0 ? Colors.grey : Colors.red,
                    ),
                    onPressed: () {
                      if (formKeys[_currentPosition].currentState != null) {
                        pageData[_currentPosition] =
                            formKeys[_currentPosition].currentState!.instantValue;
                        print(pageData);
                        _updatePosition(max(--_currentPosition, 0));
                      }
                    },
                    child: const Text(
                      'Zurück',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
            _currentPosition == (_totalPages - 1)
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      if (formKeys[_currentPosition].currentState != null &&
                          formKeys[_currentPosition].currentState!.validate()) {
                        pageData[_currentPosition] =
                            formKeys[_currentPosition].currentState!.instantValue;
                        print(pageData);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      'Fertig',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      if (formKeys[_currentPosition].currentState != null &&
                          formKeys[_currentPosition].currentState!.validate()) {
                        pageData[_currentPosition] = formKeys[_currentPosition]
                            .currentState!
                            .instantValue; // _formKey.currentState?.instantValue.toString()
                        _updatePosition(min(++_currentPosition, _totalPages - 1));
                      }
                    },
                    child: const Text(
                      'Weiter',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ]),
        ],
      ),
    );
  }
}
