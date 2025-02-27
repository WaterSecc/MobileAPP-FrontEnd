import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watersec_mobileapp_front/Model/Invoice_service.dart';
import 'package:watersec_mobileapp_front/Model/daily_waterConsumption_service.dart';
import 'package:watersec_mobileapp_front/Model/quarter_waterConsumption_service.dart';
import 'package:watersec_mobileapp_front/ViewModel/loginViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/watermeterViewModel.dart';
import 'package:provider/provider.dart'; // Provider for accessing other view models

class DashboardViewModel extends ChangeNotifier {
  final _waterConsumptionService = DailyWaterConsumptionService();
  final _quarterwaterConsumptionService = QuarterWaterConsumptionService();
  final _invoiceService = InvoiceService();
  final _loginViewModel = LoginViewModel();

  double _currentWaterConsumption = 0.0;
  double _waterConsumptionPercentage = 0.0;
  double _quarterWaterConsumption = 0.0;
  double _quarterwaterConsumptionPercentage = 0.0;

  double _sonedeAmount = 0.0;
  double _onasAmount = 0.0;
  double _totalAmount = 0.0;
  double _consumptionPercentLevel = 0.0;
  double _consumptionLevel = 0;

  List<String> _selectedWaterMeterIds = []; // Store selected water meters

  // Getters for the consumption and amount values
  double get currentWaterConsumption => _currentWaterConsumption;
  double get waterConsumptionPercentage => _waterConsumptionPercentage;
  double get quarterWaterConsumption => _quarterWaterConsumption;
  double get quarterwaterConsumptionPercentage =>
      _quarterwaterConsumptionPercentage;
  double get sonedeAmount => _sonedeAmount;
  double get onasAmount => _onasAmount;
  double get totalAmount => _totalAmount;
  double get consumptionPercentLevel => _consumptionPercentLevel;
  double get consumptionLevel => _consumptionLevel;

  // Fetch daily water consumption with selected water meters from WaterMetersViewModel
  Future<void> fetchDailyWaterConsumption(BuildContext context) async {
    try {
      final accessToken = await _loginViewModel.getAccessToken();

      // Fetch selected meters from WaterMetersViewModel
      final waterMetersViewModel =
          Provider.of<WaterMetersViewModel>(context, listen: false);

      // Ensure this list is correctly populated
      _selectedWaterMeterIds = List.from(waterMetersViewModel.selectedMeterIds);

      var waterConsumptionResponse;

      if (accessToken != null) {
        if (_selectedWaterMeterIds.isEmpty) {
          // No water meters selected
          waterConsumptionResponse = await _waterConsumptionService
              .getDailyWaterConsumption(accessToken, []);
        } else {
          // Fetch consumption with selected water meters
          waterConsumptionResponse = await _waterConsumptionService
              .getDailyWaterConsumption(accessToken, _selectedWaterMeterIds);
        }

        // Assign values using the response
        _currentWaterConsumption =
            waterConsumptionResponse.currentConsumption.toDouble();
        _waterConsumptionPercentage =
            waterConsumptionResponse.percentage.toDouble();

        notifyListeners();
      } else {
        print('Access token is not available');
      }
    } catch (e) {
      print('Error fetching water consumption: $e');
    }
  }

  // Fetch quarterly water consumption with selected water meters from WaterMetersViewModel
  Future<void> fetchQuarterWaterConsumption(BuildContext context) async {
    try {
      final accessToken = await _loginViewModel.getAccessToken();

      // Fetch selected meters from WaterMetersViewModel
      final waterMetersViewModel =
          Provider.of<WaterMetersViewModel>(context, listen: false);

      List<String> selectedMeterIds = waterMetersViewModel.selectedMeterIds;

      if (accessToken != null) {
        final quarterwaterConsumptionResponse =
            await _quarterwaterConsumptionService.getQuarterWaterConsumption(
                accessToken, selectedMeterIds);

        _quarterWaterConsumption =
            (quarterwaterConsumptionResponse.current_month_consumption ?? 0)
                .toDouble();
        _quarterwaterConsumptionPercentage =
            (quarterwaterConsumptionResponse.percentage ?? 0).toDouble();

        notifyListeners();
      } else {
        print('Access token is not available');
      }
    } catch (e) {
      print('Error fetching quarterly water consumption: $e');
    }
  }

  // Fetch invoices with selected water meters from WaterMetersViewModel
  Future<void> fetchInvoices(BuildContext context) async {
    try {
      final accessToken = await _loginViewModel.getAccessToken();

      // Fetch selected meters from WaterMetersViewModel
      final waterMetersViewModel =
          Provider.of<WaterMetersViewModel>(context, listen: false);

      List<String> selectedMeterIds = waterMetersViewModel.selectedMeterIds;

      var invoiceResponse;

      if (accessToken != null) {
        if (selectedMeterIds.isEmpty) {
          // No water meters selected, fetch invoices without 'locations[]'
          invoiceResponse = await _invoiceService.getInvoice(accessToken, []);
        } else {
          // Fetch invoices with selected water meters
          invoiceResponse =
              await _invoiceService.getInvoice(accessToken, selectedMeterIds);
        }

        _sonedeAmount = invoiceResponse.sonedeAmount.toDouble();
        _onasAmount = invoiceResponse.onasAmount.toDouble();
        _totalAmount = invoiceResponse.totalAmount.toDouble();
        _consumptionPercentLevel =
            invoiceResponse.consumptionPercentLevel.toDouble();
        _consumptionLevel = invoiceResponse.consumptionLevel.toDouble();

        notifyListeners();
      } else {
        print('Access token is not available');
      }
    } catch (e) {
      print('Error fetching invoices: $e');
    }
  }
}
