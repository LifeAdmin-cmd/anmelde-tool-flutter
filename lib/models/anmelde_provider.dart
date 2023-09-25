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

  /// General Functions

  void clearData() {
    _registeredPersons = [];
    _savedPersons = [];
    _pageData = {};
  }
}
