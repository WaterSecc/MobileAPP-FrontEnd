import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/View/components/wavepainter.dart';

class WaterLevelIndicator extends StatefulWidget {
  final double waterLevel;
  final Color backgroundColor;
  final Color waterColor;
  final String text;
  final TextStyle textStyle;
  final double strokeWidth;

  const WaterLevelIndicator({
    Key? key,
    required this.waterLevel,
    required this.backgroundColor,
    required this.waterColor,
    required this.text,
    required this.textStyle,
    this.strokeWidth = 2.0,
  }) : super(key: key);

  @override
  _WaterLevelIndicatorState createState() => _WaterLevelIndicatorState();
}

class _WaterLevelIndicatorState extends State<WaterLevelIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _waterLevelAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _waterLevelAnimation =
        Tween<double>(begin: 0.0, end: widget.waterLevel).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5),
      child: AnimatedBuilder(
        animation: _waterLevelAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: WaterLevelPainter(
              waterLevel: _waterLevelAnimation.value,
              backgroundColor: widget.backgroundColor,
              waterColor: widget.waterColor,
              text: widget.text,
              textStyle: widget.textStyle,
              strokeWidth: widget.strokeWidth,
            ),
            child: SizedBox(
              width: 65,
              height: 65,
            ),
          );
        },
      ),
    );
  }
}
