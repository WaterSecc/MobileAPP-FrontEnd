import 'package:flutter/material.dart';

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
                color: Color.fromRGBO(90, 90, 90, 1),
              ),
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Text(
                    widget.consommationtxt,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    widget.consommationInt.toString() + 'L',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.normal,
                      fontSize: 33,
                    ),
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
                color: Color.fromRGBO(51, 132, 198, 1),
              ),
              child: Column(
                children: [
                  SizedBox(height: 60),
                  Text(
                    'Froid:',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    widget.froid.toString() + 'L',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.normal,
                      fontSize: 22,
                    ),
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
                color: Color.fromRGBO(249, 65, 68, 1),
              ),
              child: Column(
                children: [
                  SizedBox(height: 60),
                  Text(
                    'Chaud:',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    widget.chaud.toString() + 'L',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.normal,
                      fontSize: 22,
                    ),
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
