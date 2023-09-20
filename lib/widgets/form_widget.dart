import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:galaxias_anmeldetool/widgets/module_builder.dart';

class FormWidget extends StatefulWidget {
  const FormWidget({Key? key});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final List<Map<String, dynamic>> moduleData = [
    {"param1": "value1", "param2": "value2"},
    {"param1": "value3", "param2": "value4"},
    {"param1": "value1", "param2": "value2"},
    {"param1": "value3", "param2": "value4"},
    {"param1": "value3", "param2": "value4"},
    // Add data for more modules as needed
  ];

  int _currentPosition = 0;

  Map<int, Map<String, dynamic>> pageData = {};

  late final int _totalPages;
  late final List<GlobalKey<FormBuilderState>> formKeys;

  @override
  void initState() {
    super.initState();
    _totalPages = moduleData.length;
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

  Widget _buildRow(List<Widget> widgets, {
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
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        _buildRow([
          // DotsIndicator for previous dots (grey color)
          _currentPosition > 0 ? DotsIndicator(
            dotsCount: _currentPosition,
            position: _currentPosition - 1,
            decorator: DotsDecorator(
              size: Size.square(20.0),
              activeSize: Size(20.0, 20.0),
              color: Colors.blue.shade200, // Set the default color for previous dots
              activeColor: Colors.blue.shade200, // Set the same color for previous dots
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
              ),
              spacing: EdgeInsets.all(8.0), // Adjust the spacing between dots as needed
            ),
          ) : Container(),

          // DotsIndicator for the active dot (blue color)
          DotsIndicator(
            dotsCount: _totalPages - _currentPosition,
            position: 0, // Start from the first dot
            decorator: DotsDecorator(
              size: Size.square(20.0),
              activeSize: Size(20.0, 20.0),
              color: Colors.grey, // Set the default color for dots above the active page
              activeColor: Colors.blue.shade600, // Set the active color for the current page
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
              ),
              spacing: EdgeInsets.all(8.0), // Adjust the spacing between dots as needed
            ),
          ),
        ], mainAxisAlignment: MainAxisAlignment.center),
        const Divider(),
        FormBuilder(
          key: formKeys[_currentPosition],
          initialValue: pageData[_currentPosition] ?? {},
          child: ModuleBuilder(
            param1: pageData,
            param2: moduleData[_currentPosition],
          ),
        ),
        _buildRow([
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
              _currentPosition == 0 ? Colors.grey : Colors.red,
            ),
            onPressed: () {
              _updatePosition(max(--_currentPosition, 0));
            },
            child: const Text(
              'Zurück',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              if (formKeys[_currentPosition].currentState != null &&
                  formKeys[_currentPosition].currentState!.validate()) {
                pageData[_currentPosition] =
                    formKeys[_currentPosition].currentState!.instantValue; // _formKey.currentState?.instantValue.toString()
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
    );
  }
}
