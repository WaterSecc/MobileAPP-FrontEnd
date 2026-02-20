import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watersec_mobileapp_front/Model/year_period_waterConsumption_service.dart';
import 'package:watersec_mobileapp_front/ViewModel/loginViewModel.dart';
import 'package:watersec_mobileapp_front/classes/consumption.dart';

class YearPeriodConsumptionViewModel extends ChangeNotifier {
  final yearperiodconsumptionservice = YearPeriodConsumptionService();
  final _loginViewModel = LoginViewModel();

  List<String> _dates = [];
  List<Consumption> _consumptions = [];
  num _total = 0.0;
  List<String> _selectedWaterMeterIds = []; // Store selected water meters

  List<String> get dates => _dates;
  List<Consumption> get consumptions => _consumptions;
  num get total => _total;
  List<String> get selectedWaterMeterIds => _selectedWaterMeterIds;

  YearPeriodConsumptionViewModel() {
    _loadSelectedWaterMeters();
  }

  // Load stored selected water meter IDs from SharedPreferences
  Future<void> _loadSelectedWaterMeters() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? storedMeters = prefs.getStringList('selectedWaterMeterIds');
    if (storedMeters != null && storedMeters.isNotEmpty) {
      _selectedWaterMeterIds = storedMeters;
      notifyListeners();
    }
  }

  // Save selected water meter IDs to SharedPreferences
  Future<void> _saveSelectedWaterMeters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedWaterMeterIds', _selectedWaterMeterIds);
  }

  // Update the list of selected water meters and persist them
  void updateSelectedWaterMeters(List<String> selectedMeterIds) {
    _selectedWaterMeterIds = selectedMeterIds;
    _saveSelectedWaterMeters(); // Persist the selection
    notifyListeners();
  }

  // Fetch year period water consumption with optional selected water meter IDs
  Future<void> fetchYearPeriodConsumption() async {
    try {
      final accessToken = await _loginViewModel.getAccessToken();
      if (accessToken != null) {
        final thisyearperiodconsumptionResponse =
            await yearperiodconsumptionservice.getYearPeriodConsumption(
                accessToken, _selectedWaterMeterIds);
        _dates = thisyearperiodconsumptionResponse.dates;
        _total = thisyearperiodconsumptionResponse.total;
        _consumptions = thisyearperiodconsumptionResponse.consumptions;
        notifyListeners();
      } else {
        print('Access token is not available');
      }
    } catch (e) {
      print('Error fetching consumption, period; year: $e');
    }
  }
}
