import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watersec_mobileapp_front/Model/settingsGET_service.dart';
import 'package:watersec_mobileapp_front/Model/settingsSET_service.dart';
import 'package:watersec_mobileapp_front/ViewModel/loginViewModel.dart';
import 'package:watersec_mobileapp_front/classes/settings.dart';

class SettingsViewModel extends ChangeNotifier {
  final getSettingsService = GetSettingsService();
  final _loginViewModel = LoginViewModel();
  final setSettingsService = SetSettingsService();
  SensorData? _sensorData;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  SensorData? get sensorData => _sensorData;

  int _globalConsumptionThreshold = 0;
  List<SensorConsumptionThreshold> _sensorsConsumptionsThresholds = [];
  List<String> _selectedDeviceIds = []; // Store selected device IDs

  // Getters for the data
  int get globalConsumptionThreshold => _globalConsumptionThreshold;
  List<SensorConsumptionThreshold> get sensorsConsumptionsThresholds =>
      _sensorsConsumptionsThresholds;
  List<String> get selectedDeviceIds => _selectedDeviceIds;

  SettingsViewModel() {
    _loadSelectedDevices();
  }

  // Load stored selected device IDs from SharedPreferences
  Future<void> _loadSelectedDevices() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? storedDevices = prefs.getStringList('selectedDeviceIds');
    if (storedDevices != null && storedDevices.isNotEmpty) {
      _selectedDeviceIds = storedDevices;
      notifyListeners();
    }
  }

  // Save selected device IDs to SharedPreferences
  Future<void> _saveSelectedDevices() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedDeviceIds', _selectedDeviceIds);
  }

  // Fetch the settings data (global threshold and sensors) with optional selected device IDs
  Future<void> fetchSettings() async {
    try {
      final accessToken = await _loginViewModel.getAccessToken();
      if (accessToken != null) {
        print('Fetching settings...');

        SensorData sensorData;

        // Fetch the data
        if (_selectedDeviceIds.isEmpty) {
          sensorData = await getSettingsService.getSettings(accessToken);
        } else {
          sensorData = await getSettingsService.getSettings(
              accessToken, _selectedDeviceIds);
        }

        print('Settings fetched successfully: $sensorData');

        // Update the ViewModel with the fetched data
        _globalConsumptionThreshold = sensorData.globalConsumptionThreshold;
        _sensorsConsumptionsThresholds =
            sensorData.sensorsConsumptionsThresholds;
        _sensorData = sensorData;
        notifyListeners();
      } else {
        print('Access token is not available');
      }
    } catch (e) {
      print('Error fetching settings: $e');
    }
  }

  // Send updated sensor data to the backend
  Future<void> updateSensorData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final accessToken = await _loginViewModel.getAccessToken();
      if (accessToken == null) {
        throw Exception('Access token is not available');
      }

      if (_sensorData == null) {
        throw Exception('Sensor data is null');
      }

      // Send the entire updated sensor data to the backend
      await setSettingsService.setSettings(accessToken, _sensorData!);
      print('Sensor data successfully updated on the backend.');
    } catch (e) {
      print('Error updating sensor data: $e');
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update sensor data locally and sync with the backend
  void updateSensor(SensorConsumptionThreshold updatedSensor) {
    if (_sensorData == null) {
      print('Error: _sensorData is null');
      return;
    }

    int index = _sensorData!.sensorsConsumptionsThresholds.indexWhere(
        (sensor) => sensor.identifier == updatedSensor.identifier);

    if (index != -1) {
      _sensorData!.sensorsConsumptionsThresholds[index] = updatedSensor;
      notifyListeners(); // Notify listeners to update the UI

      // Now, update the backend with the modified data
      updateSensorData().then((_) {
        print('Changes successfully sent to the backend.');
      }).catchError((error) {
        print('Error while updating the backend: $error');
      });
    } else {
      print('Error: Sensor with identifier ${updatedSensor.identifier} not found');
    }
  }

  // Update global threshold and send it to the backend
  Future<bool> updateGlobalThreshold(int newThreshold) async {
  _isLoading = true;
  notifyListeners();

  try {
    final accessToken = await _loginViewModel.getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token is not available');
    }

    // Update the local global threshold value
    _globalConsumptionThreshold = newThreshold;

    // Update the sensor data object with the new global threshold
    if (_sensorData != null) {
      _sensorData = _sensorData!.copyWith(globalConsumptionThreshold: newThreshold);

      // Send updated data (global threshold + sensors) to backend
      await setSettingsService.setSettings(accessToken, _sensorData!);
      print('Global threshold updated successfully in the backend.');
      return true; // Indicate success
    } else {
      throw Exception('Sensor data is null');
    }
  } catch (e) {
    print('Error updating global threshold: $e');
    return false; // Indicate failure
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

}
