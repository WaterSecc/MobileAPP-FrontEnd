import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/Model/category_service.dart';
import 'package:watersec_mobileapp_front/ViewModel/loginViewModel.dart';
import 'package:watersec_mobileapp_front/classes/category.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  final _loginViewModel = LoginViewModel();

  List<Category> _categories = [];  // Store the list of categories
  List<Category> get categories => _categories;  // Getter for categories

  // Method to fetch categories from the API and remove duplicates
  Future<void> fetchCategories() async {
    try {
      final accessToken = await _loginViewModel.getAccessToken();
      if (accessToken != null) {
        print('Fetching categories...');
        List<Category> fetchedCategories = await _categoryService.fetchCategories(accessToken);

        // Use a Set to ensure categories are unique
        Set<Category> uniqueCategories = {};
        for (var category in fetchedCategories) {
          uniqueCategories.add(category); // Set automatically handles duplicates
        }

        _categories = uniqueCategories.toList();
        print('Categories fetched successfully: $_categories');
        notifyListeners();  // Trigger UI updates
      } else {
        print('Access token is not available');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

   // Method to get a unique list of subcategory names by mainCategoryId
  List<String> getSubCategoryNames(int mainCategoryId) {
    return _categories
        .where((cat) => cat.mainCategoryId == mainCategoryId)
        .map((cat) => cat.subCategoryName)
        .toSet()  // Ensure uniqueness
        .toList();
  }

  // Method to get unique main category names
  List<String> getUniqueMainCategories() {
    return _categories
        .map((cat) => cat.mainCategoryName)
        .toSet()  // Ensure uniqueness
        .toList();
  }

  // Method to get the main category name by ID
  String getMainCategoryName(int mainCategoryId) {
    final category = _categories.firstWhere(
        (cat) => cat.mainCategoryId == mainCategoryId,
        orElse: () => Category.empty());
    return category.mainCategoryName;
  }

  // Method to get the subcategory name by ID
  String getSubCategoryName(int subCategoryId) {
    final category = _categories.firstWhere(
        (cat) => cat.subCategoryId == subCategoryId,
        orElse: () => Category.empty());
    return category.subCategoryName;
  }
  int getMainCategoryIdByName(String mainCategoryName) {
  final category = _categories.firstWhere(
    (cat) => cat.mainCategoryName == mainCategoryName,
    orElse: () => Category.empty(),  // Handle no match case
  );
  return category.mainCategoryId;
}

int getSubCategoryIdByName(String subCategoryName) {
  final category = _categories.firstWhere(
    (cat) => cat.subCategoryName == subCategoryName,
    orElse: () => Category.empty(),  // Handle no match case
  );
  return category.subCategoryId;
}


}
