import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watersec_mobileapp_front/Model/devices_service.dart';
import 'package:watersec_mobileapp_front/ViewModel/loginViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/watermeterViewModel.dart';
import 'package:watersec_mobileapp_front/classes/devices.dart';

class DevicesViewModel extends ChangeNotifier {
  final deviceservice = DevicesService();
  final _loginViewModel = LoginViewModel();

  List<Building> _buildings = [];
  List<String> _selectedFloorIds = []; // Store selected floor IDs
  List<String> _selectedWaterMeterIds = []; // Store selected water meters

  // Getters
  List<Building> get buildings => _buildings;
  List<String> get selectedFloorIds => _selectedFloorIds;

  // Update selected floor IDs and persist them
  void updateSelectedFloorIds(List<String> selectedFloorIds) async {
    _selectedFloorIds = selectedFloorIds;
    await _saveSelectedFloors(selectedFloorIds);
    notifyListeners();
  }

  // Fetch devices (buildings and floors) based on selected water meters
  Future<void> fetchDevices(BuildContext context) async {
    try {
      final accessToken = await _loginViewModel.getAccessToken();
      // Fetch selected meters from WaterMetersViewModel
      final waterMetersViewModel =
          Provider.of<WaterMetersViewModel>(context, listen: false);

      // Ensure this list is correctly populated
      _selectedWaterMeterIds = List.from(waterMetersViewModel.selectedMeterIds);
      if (accessToken != null) {
        List<Building> buildings =
            await deviceservice.getDevices(accessToken, _selectedWaterMeterIds);
        _buildings = buildings;
        print(_buildings.first.floors);
        notifyListeners(); // Trigger UI update
      } else {
        print('Access token is not available');
      }
    } catch (e) {
      print('Error fetching devices list: $e');
    }
  }

  // Save selected floor IDs to SharedPreferences
  Future<void> _saveSelectedFloors(List<String> selectedFloorIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selected_floor_ids', selectedFloorIds);
  }

  // Load selected floor IDs from SharedPreferences
  Future<void> loadSelectedFloors() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFloorIds = prefs.getStringList('selected_floor_ids') ?? [];
    notifyListeners();
  }

  // Clear selected floors (if needed)
  Future<void> clearSelectedFloors() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_floor_ids');
    _selectedFloorIds.clear();
    notifyListeners();
  }
}
