import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AnmeldeProvider with ChangeNotifier {
  List<Map<String, dynamic>> _registeredPersons = [];
  List<Map<String, dynamic>> _savedPersons = [];
  Map<int, dynamic> _pageData = {};

  Map<int, dynamic> get pageData => _pageData;
  List<Map<String, dynamic>> get registeredPersons => _registeredPersons;
  List<Map<String, dynamic>> get savedPersons => _savedPersons;

  /// Person Functions


  bool _looksLikeDateTime(String value) {
    try {
      DateTime.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Convert any string that looks like DateTime to DateTime object in Map
  dynamic _convertNestedStringDateToDateTime(dynamic item) {
    if (item is String && _looksLikeDateTime(item)) {
      return DateTime.parse(item);
    } else if (item is Map) {
      item.updateAll((key, value) => _convertNestedStringDateToDateTime(value));
      return item;
    } else {
      return item;
    }
  }

  Map<String, dynamic> handleWrongDataTypes(Map<String, dynamic> person) {
    if (person['birthday'] != null) {
      person['birthday'] = DateTime.parse(person['birthday'] as String);
    }
    if (person['eatingHabits'] != null) {
      List<String> personEatingHabits = (person['eatingHabits'] as List).map((item) => item.toString()).toList();
      person['eatingHabits'] = personEatingHabits;
    }
    return person;
  }

  void addRegisteredPerson(Map<String, dynamic> person) {
    handleWrongDataTypes(person);
    _registeredPersons.add(person);
    notifyListeners();
  }

  void addSavedPerson(Map<String, dynamic> person) {
    handleWrongDataTypes(person);
    _savedPersons.add(person);
    notifyListeners();
  }

  void updateRegisteredPerson(int index, Map<String, dynamic> person) {
    _registeredPersons[index] = person;
    notifyListeners();
  }

  void updateSavedPerson(int index, Map<String, dynamic> person) {
    _savedPersons[index] = person;
    notifyListeners();
  }

  void removeRegisteredPerson(Map<String, dynamic> person) {
    _registeredPersons.remove(person);
    notifyListeners();
  }

  void removeSavedPerson(Map<String, dynamic> person) {
    _savedPersons.remove(person);
    notifyListeners();
  }

  void clearPersons() {
    _registeredPersons = [];
    _savedPersons = [];
  }

  /// pageData Functions

  void initPageDate(Map<int, dynamic> pageData) {
    _convertNestedStringDateToDateTime(pageData);
    _pageData = pageData;
    notifyListeners();
  }

  void addPageData(int index, Map<String, dynamic> pageData) {
    _convertNestedStringDateToDateTime(pageData);
    _pageData[index] = pageData;
    notifyListeners();
  }

  void updatePageData(int index, Map<String, dynamic> pageData) {
    _convertNestedStringDateToDateTime(pageData);
    _pageData[index] = pageData;
    notifyListeners();
  }


  void removePageData(Map<String, dynamic> pageData) {
    pageData.remove(pageData);
    notifyListeners();
  }

  /// Fahrten List

  List<dynamic>? _allData;
  bool _isLoading = false;
  Map<String, int>? categoryCount;

  bool get isLoading => _isLoading;
  List<dynamic>? get allData => _allData;

  Future<void> fetchData({bool forceUpdate = false}) async {
    if (!forceUpdate && _allData != null) return;

    _isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse('https://api.larskra.eu/fahrten'));

    if (response.statusCode == 200) {
      _allData = json.decode(response.body);
      categoryCount = countStatusValues(_allData!);
    } else {
      // Handle error
    }

    _isLoading = false;
    notifyListeners();
  }

  Map<String, int> countStatusValues(List<dynamic> data) {
    Map<String, int> counts = {};
    for (var item in data) {
      final status = item['status'] as String;
      counts[status] = (counts[status] ?? 0) + 1;
    }
    return counts;
  }

  /// Basic API route data

  List<dynamic> _modules = [];
  List<dynamic> _genders = [];
  List<dynamic> _eatingHabits = [];

  List<dynamic> get modules => _modules;
  List<dynamic> get genders => _genders;
  List<dynamic> get eatingHabits => _eatingHabits;

  void initModules(List<dynamic> modules) {
    _convertNestedStringDateToDateTime(modules);
    _modules = modules;
    notifyListeners();
  }

  void initGenders(List<dynamic> genders) {
    _convertNestedStringDateToDateTime(genders);
    _genders = genders;
    notifyListeners();
  }

  void initEatingHabits(List<dynamic> eatingHabits) {
    _convertNestedStringDateToDateTime(eatingHabits);
    _eatingHabits = eatingHabits;
    notifyListeners();
  }


  /// General Functions

  void clearData() {
    _registeredPersons = [];
    _savedPersons = [];
    _pageData = {};
  }

  String getInputLabelForDropdownValue(String? value) {
    switch (value) {
      case "1":
        return "Welcher Bahnhof?";
      case "2":
        return "Welche Reisegesellschaft?";
      case "3":
        return "Anzahl der PKW";
      case "4":
        return "Wie reist du an?";
      default:
        return "Details";
    }
  }

  final List<dynamic> _anreiseData = [
    {"id": 1, "name": "Öffis"},
    {"id": 2, "name": "Reisebus"},
    {"id": 3, "name": "PKW"},
    {"id": 4, "name": "Sonstiges"}
  ];

  List<dynamic> get anreiseData => _anreiseData;
}
