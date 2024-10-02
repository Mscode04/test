import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  bool _isSearchSelected = false;

  bool get isSearchSelected => _isSearchSelected;

  void selectSearch() {
    _isSearchSelected = true;
    notifyListeners(); 
  }

  void deselectSearch() {
    _isSearchSelected = false;
    notifyListeners(); 
  }

  
}
