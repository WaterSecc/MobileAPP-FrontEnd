import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class MyCircularDesign extends StatefulWidget {
  const MyCircularDesign({
    Key? key,
    required this.consommationtxt,
    required this.consommationInt,
    required this.chaud,
    required this.froid,
  }) : super(key: key);

  final String consommationtxt;
  final double consommationInt;
  final double chaud;
  final double froid;

  @override
  State<MyCircularDesign> createState() => _MyCircularDesignState();
}

class _MyCircularDesignState extends State<MyCircularDesign> {
  int _selectedCircleIndex = 0;
  double _circleSizeDelta = 0;

  void _increaseCircleSize() {
    setState(() {
      _circleSizeDelta += 20; // Increase the size by 20
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          top: _selectedCircleIndex == 0 ? 0 : 15,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedCircleIndex = 0;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _selectedCircleIndex == 0 ? 270 + _circleSizeDelta : 260,
              height: _selectedCircleIndex == 0 ? 270 + _circleSizeDelta : 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: gray,
              ),
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Text(
                    widget.consommationtxt,
                    style: TextStyles.subtitle1Style(white),
                  ),
                  Text(
                    widget.consommationInt.toString() + 'L',
                    style: TextStyles.Header2Style(),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          top: _selectedCircleIndex == 1 ? 0 : 230,
          left: 20,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedCircleIndex = 1;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _selectedCircleIndex == 1 ? 190 + _circleSizeDelta : 175,
              height: _selectedCircleIndex == 1 ? 190 + _circleSizeDelta : 175,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: blue,
              ),
              child: Column(
                children: [
                  SizedBox(height: 60),
                  Text(
                    AppLocale.Froid.getString(context),
                    style: TextStyles.subtitle1Style(white),
                  ),
                  Text(
                    widget.froid.toString() + 'L',
                    style: TextStyles.Header3Style(),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          top: _selectedCircleIndex == 2 ? 0 : 200,
          right: 20,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedCircleIndex = 2;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _selectedCircleIndex == 2 ? 190 + _circleSizeDelta : 175,
              height: _selectedCircleIndex == 2 ? 190 + _circleSizeDelta : 175,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: red,
              ),
              child: Column(
                children: [
                  SizedBox(height: 60),
                  Text(
                    AppLocale.Chaud.getString(context),
                    style: TextStyles.subtitle1Style(white),
                  ),
                  Text(
                    widget.chaud.toString() + 'L',
                    style: TextStyles.Header3Style(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
