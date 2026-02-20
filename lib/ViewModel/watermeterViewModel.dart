import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watersec_mobileapp_front/Model/watermeters_service.dart';
import 'package:watersec_mobileapp_front/ViewModel/loginViewModel.dart';
import 'package:watersec_mobileapp_front/classes/watermeters.dart';

class WaterMetersViewModel extends ChangeNotifier {
  final WaterMeterService watermeterservice = WaterMeterService();
  final _loginViewModel = LoginViewModel();

  List<WaterMeters> _watermeters = [];
  List<String> _selectedMeterIds = []; // Store selected meter IDs

  List<WaterMeters> get watermeters => _watermeters;
  List<String> get selectedMeterIds => _selectedMeterIds;

  WaterMetersViewModel() {
    _loadSelectedMeters(); // Load saved selected meters when the ViewModel is initialized
  }

  Future<void> fetchWaterMeters() async {
    try {
      final accessToken = await _loginViewModel.getAccessToken();
      if (accessToken != null) {
        final waterMeterResponse =
            await watermeterservice.getWaterMeters(accessToken);
        _watermeters = waterMeterResponse.watermeterlist;
        notifyListeners();
      } else {
        print('Access token is not available');
      }
    } catch (e) {
      print('Error fetching water meters list: $e'); 
    }
  }

  // Update selected meters and persist the selection
  void updateSelectedMeters(List<String> selectedMeterIds) async {
    _selectedMeterIds = selectedMeterIds;
    await _saveSelectedMeters(
        selectedMeterIds); // Save the selection to SharedPreferences
    notifyListeners();
    print(selectedMeterIds);
  }

  // Save selected water meters to SharedPreferences
  Future<void> _saveSelectedMeters(List<String> selectedMeterIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selected_water_meters', selectedMeterIds);
  }

  // Load selected water meters from SharedPreferences
  Future<void> _loadSelectedMeters() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedMeterIds = prefs.getStringList('selected_water_meters') ?? [];
    notifyListeners(); // Notify listeners after loading the data
  }

  // Clear selected meters (if needed)
  Future<void> clearSelectedMeters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_water_meters');
    _selectedMeterIds.clear();
    notifyListeners();
  }
}
