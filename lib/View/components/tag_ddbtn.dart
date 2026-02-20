import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class MyTagDropDownBtn extends StatefulWidget {
  final List<String> selectedTags;
  final Function(String) onTagSelected;
  final String selectedTag;
  final List<String> devicesList;

  const MyTagDropDownBtn({
    required this.selectedTags,
    required this.onTagSelected,
    required this.selectedTag,
    required this.devicesList,
  });

  @override
  State<MyTagDropDownBtn> createState() => _MyTagDropDownBtnState();
}

class _MyTagDropDownBtnState extends State<MyTagDropDownBtn> {
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
          child: DropdownButton<String>(
            value:
                null, // Allow the dropdown to stay open for multiple selections
            hint: Text(
              AppLocale.filtrer.getString(context),
              style: TextStyles.subtitle3Style(
                  Theme.of(context).colorScheme.secondary),
            ),
            items: widget.devicesList.map((String device) {
              return DropdownMenuItem<String>(
                value: device,
                child: Text(
                  device,
                  style: TextStyles.subtitle3Style(
                      Theme.of(context).colorScheme.secondary),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null && !widget.selectedTags.contains(newValue)) {
                widget.onTagSelected(newValue); // Call the toggle method
              }
            },
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
            children: widget.selectedTags.map((tag) {
              return Chip(
                deleteIconColor: Theme.of(context).colorScheme.secondary,
                label: Text(
                  tag,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                onDeleted: () {
                  widget.onTagSelected(tag);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
