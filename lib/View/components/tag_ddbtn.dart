import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

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
          margin: EdgeInsets.only(top: 10, right: 7, left: 7),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
            ),
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedTag,
            hint: Text(
              'Filtrer par tag',
              style: TextStyles.subtitle3Style(
                  Theme.of(context).colorScheme.secondary),
            ),
            items: <DropdownMenuItem<String>>[
              DropdownMenuItem<String>(
                value: 'Filtrer par tag',
                child: Text(
                  'Filtrer par tag',
                  style: TextStyles.subtitle3Style(
                      Theme.of(context).colorScheme.secondary),
                ),
              ),
              DropdownMenuItem<String>(
                value: 'Salle de bain',
                child: Text(
                  'Salle de bain',
                  style: TextStyles.subtitle3Style(
                      Theme.of(context).colorScheme.secondary),
                ),
              ),
              DropdownMenuItem<String>(
                value: 'Robinet',
                child: Text(
                  'Robinet',
                  style: TextStyles.subtitle3Style(
                      Theme.of(context).colorScheme.secondary),
                ),
              ),
              DropdownMenuItem<String>(
                value: 'Cuisine',
                child: Text(
                  'Cuisine',
                  style: TextStyles.subtitle3Style(
                      Theme.of(context).colorScheme.secondary),
                ),
              ),
              DropdownMenuItem<String>(
                value: 'Lavabo',
                child: Text(
                  'Lavabo',
                  style: TextStyles.subtitle3Style(
                      Theme.of(context).colorScheme.secondary),
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
            icon: Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.secondary,
            ),
            iconSize: 14,
            elevation: 6,
            style: TextStyles.subtitle3Style(
                Theme.of(context).colorScheme.secondary),
          ),
        ),
        // Container to display selected items
        Container(
          padding: EdgeInsets.only(top: 5),
          child: Wrap(
            spacing: 5,
            children: selectedTags.map((tag) {
              return Chip(
                deleteIconColor: Theme.of(context).colorScheme.secondary,
                label: Text(
                  tag,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
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
