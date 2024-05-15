import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:watersec_mobileapp_front/View/components/dateselection_container.dart';
import 'package:watersec_mobileapp_front/View/components/tag_ddbtn.dart';
import 'package:watersec_mobileapp_front/View/components/text_button.dart';

class CustomPopup extends StatefulWidget {
  final Function(List<String>) onFiltersSelected;
  final String defaultTagText;

  const CustomPopup({
    Key? key,
    required this.onFiltersSelected,
    required this.defaultTagText,
  }) : super(key: key);

  @override
  State<CustomPopup> createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isTagContainerOpen = false;
  bool _isDateContainerOpen = false;
  List<String> selectedTags = [];
  String selectedTag = 'Filtrer par tag';
  DateTime _selectedDate1 = DateTime.now();
  DateTime _selectedDate2 = DateTime.now();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleTagContainer() {
    setState(() {
      _isTagContainerOpen = !_isTagContainerOpen;
      if (_isTagContainerOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _toggleDateContainer() {
    setState(() {
      _isDateContainerOpen = !_isDateContainerOpen;
      if (_isDateContainerOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _toggleTag(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }
    });
  }

  void _applyFilters() {
    widget.onFiltersSelected(selectedTags);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width;
    final dialogHeight = screenSize.height;

    return Dialog(
      insetPadding: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.all(13),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: Color.fromRGBO(255, 255, 255, 0.8)),
        width: dialogWidth,
        height: dialogHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6),
            Container(
              width: dialogWidth,
              height: dialogHeight * 0.23,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  width: 0.3,
                  style: BorderStyle.solid,
                  color: Color.fromRGBO(90, 90, 90, 1),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Filtrer par Tag',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(90, 90, 90, 1),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 2),
                  MyTagDropDownBtn(
                    selectedTag: selectedTag,
                    selectedTags: selectedTags,
                    onTagSelected: _toggleTag,
                  ),
                ],
              ),
            ),
            SizedBox(height: 3),
            Container(
              width: 370,
              height: 479,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  width: 0.3,
                  style: BorderStyle.solid,
                  color: Color.fromRGBO(90, 90, 90, 1),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 6),
                  Text(
                    'Filtrer par Date',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(90, 90, 90, 1),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 2),
                  CalendarContainer(
                    selectedDate1: _selectedDate1,
                    selectedDate2: _selectedDate2,
                  ),
                ],
              ),
            ),
            SizedBox(height: 6),
            Row(
              children: [
                SizedBox(width: dialogWidth * 0.22),
                SizedBox(
                  width: 130,
                  height: 38,
                  child: FilledButton(
                    onPressed: _applyFilters,
                    child: Text(
                      'Filtrer',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Color.fromRGBO(51, 132, 198, 1))),
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  height: 38,
                  width: 130,
                  child: MyTextBtn(
                    text: 'Annuler',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
