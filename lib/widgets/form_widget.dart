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

  Widget _buildRow(List<Widget> widgets) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widgets,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        _buildRow([
          DotsIndicator(
            dotsCount: _totalPages,
            position: _currentPosition,
            onTap: (position) {
              setState(() => _currentPosition = position);
            },
            decorator: const DotsDecorator(
              size: Size.square(20.0),
              activeSize: Size(20.0, 20.0),
            ),
          ),
        ]),
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
