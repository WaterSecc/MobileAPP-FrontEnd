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
  int _selectedCircleIndex = -1;
  double _circleSize = 0;

  void _increaseCircleSize(int index) {
    setState(() {
      _selectedCircleIndex = index;
      _circleSize = 10; // Increase the size by 10
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
            onTap: () => _increaseCircleSize(0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _selectedCircleIndex == 0 ? 265 + _circleSize : 260,
              height: _selectedCircleIndex == 0 ? 265 + _circleSize : 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: gray,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 100),
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
        Positioned(
          top: 230,
          left: 20,
          child: GestureDetector(
            onTap: () => _increaseCircleSize(1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _selectedCircleIndex == 1 ? 180 + _circleSize : 175,
              height: _selectedCircleIndex == 1 ? 180 + _circleSize : 175,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
        Positioned(
          top: 230,
          right: 20,
          child: GestureDetector(
            onTap: () => _increaseCircleSize(2),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _selectedCircleIndex == 2 ? 175 + _circleSize : 175,
              height: _selectedCircleIndex == 2 ? 175 + _circleSize : 175,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: red,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
