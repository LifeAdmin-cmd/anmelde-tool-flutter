import 'package:flutter/material.dart';

class AnmeldeProvider with ChangeNotifier {
  List<Map<String, dynamic>> _registeredPersons = [];
  List<Map<String, dynamic>> _savedPersons = [];

  List<Map<String, dynamic>> get registeredPersons => _registeredPersons;
  List<Map<String, dynamic>> get savedPersons => _savedPersons;

  void addRegisteredPerson(Map<String, dynamic> person) {
    _registeredPersons.add(person);
    notifyListeners();
  }

  void addSavedPerson(Map<String, dynamic> person) {
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
}
