import 'package:flutter/material.dart';

class MyTagDropDownBtn extends StatefulWidget {
  final List<String> selectedTags;
  final Function(String) onTagSelected;
  final String selectedTag;

  const MyTagDropDownBtn({
    required this.selectedTags,
    required this.onTagSelected, 
    required this.selectedTag,
  });

  @override
  State<MyTagDropDownBtn> createState() => _MyTagDropDownBtnState();
}

class _MyTagDropDownBtnState extends State<MyTagDropDownBtn> {
  List<String> selectedTags = [];
  String? selectedTag = 'Filtrer par tag';

  @override
  void initState() {
    super.initState();
    selectedTag = widget.selectedTag;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 250,
          height: 35,
          child: DropdownButtonFormField<String>(
            value: selectedTag,
            hint: Text(
              'Filtrer par tag',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
            ),
            items: <DropdownMenuItem<String>>[
              DropdownMenuItem<String>(
                value: 'Filtrer par tag',
                child: Text(
                  'Filtrer par tag',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
              ),
              DropdownMenuItem<String>(
                value: 'Salle de bain',
                child: Text(
                  'Salle de bain',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
              ),
              DropdownMenuItem<String>(
                value: 'Robinet',
                child: Text(
                  'Robinet',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
              ),
              DropdownMenuItem<String>(
                value: 'Cuisine',
                child: Text(
                  'Cuisine',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
              ),
              DropdownMenuItem<String>(
                value: 'Lavabo',
                child: Text(
                  'Lavabo',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
              ),
            ],
            onChanged: (String? newValue) {
              setState(() {
                selectedTag = newValue;
                if (newValue != null && !selectedTags.contains(newValue)) {
                  selectedTags.add(newValue);
                }
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 14,
            elevation: 6,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
        // Container to display selected items
        Container(
          padding: EdgeInsets.only(top: 5),
          child: Wrap(
            spacing: 5,
            children: selectedTags.map((tag) {
              return Chip(
                label: Text(tag),
                onDeleted: () {
                  setState(() {
                    selectedTags.remove(tag);
                    if (selectedTag == tag) {
                      selectedTag = null;
                    }
                  });
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
