import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watersec_mobileapp_front/Model/analysisConsumption_service.dart';
import 'package:watersec_mobileapp_front/ViewModel/loginViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/watermeterViewModel.dart';
import 'package:watersec_mobileapp_front/classes/analyses_request.dart';
import 'package:watersec_mobileapp_front/classes/consumption.dart';
import 'package:watersec_mobileapp_front/classes/consumption_statsResponse.dart';
import 'package:watersec_mobileapp_front/classes/consumptiondata_analysesResponse.dart';

class AnalyticsViewModel extends ChangeNotifier {
  final _analyticsService = AnalyticsService();
  final _loginViewModel = LoginViewModel();

  List<String> _dates = [];
  List<Consumption> _consumptions = [];
  List<ConsumptionStats> _stats = [];
  double _allTotal = 0.0;
  double _allAveragePerUse = 0.0;
  double _allAveragePerDay = 0.0;
  List<String> _selectedWaterMeterIds = []; // Store selected water meters

  ConsumptionDataAnalyses? _analyticsResponse;
  AnalyticsRequest? _defaultAnalyticsRequest;

  // Getters for the analytics data and selected water meters
  ConsumptionDataAnalyses? get analyticsResponse => _analyticsResponse;
  List<String> get selectedWaterMeterIds => _selectedWaterMeterIds;
  
  AnalyticsRequest get defaultAnalyticsRequest {
    return _defaultAnalyticsRequest ??= AnalyticsRequest(
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now(),
      action: 'validate',
    );
  }
 

  // Fetch analytics data with optional selected water meter IDs
 Future<void> fetchAnalyticsData({
  required WaterMetersViewModel waterMetersViewModel, // Pass the ViewModel here
  DateTime? startDate,
  DateTime? endDate,
  List<String>? sensors,  // Optional sensors (tags)
}) async {
  try {
    final accessToken = await _loginViewModel.getAccessToken();
    if (accessToken != null) {
      // Fetch selected water meters from WaterMetersViewModel
      List<String> selectedWaterMeterIds = waterMetersViewModel.selectedMeterIds; // locations

      // Create analytics request with both sensors (tags) and locations (water meters)
      final request = AnalyticsRequest(
        startDate: startDate ?? defaultAnalyticsRequest.startDate,
        endDate: endDate ?? defaultAnalyticsRequest.endDate,
        sensors: sensors ?? [], // Use passed sensors if provided
        action: 'validate',
      );

      // Fetch analytics data with selected sensors (tags) and locations (water meters)
      _analyticsResponse = await _analyticsService.getAnalytics(request, accessToken, selectedWaterMeterIds);

      // Update state with the analytics response
      _dates = _analyticsResponse!.dates;
      _allTotal = _analyticsResponse!.allTotal;
      _allAveragePerUse = _analyticsResponse!.allAveragePerUse;
      _allAveragePerDay = _analyticsResponse!.allAveragePerDay;
      _consumptions = _analyticsResponse!.consumptions;
      _stats = _analyticsResponse!.stats;

      notifyListeners();
    } else {
      print('Access token is not available');
    }
  } catch (e) {
    print('Error fetching analytics data: $e');
  }
}


}