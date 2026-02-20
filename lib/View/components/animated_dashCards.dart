import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:watersec_mobileapp_front/colors.dart';

class MiniWaterCardAnimated extends StatelessWidget {
  final double height;
  final double fill;
  final String? topLabel;
  final String title;
  final String subtitle1;
  final String subtitle2;
  final double scale;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? trailingIconColor;
  final VoidCallback? onTap;

  const MiniWaterCardAnimated({
    Key? key,
    required this.height,
    required this.fill,
    this.topLabel,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.scale,
    this.leadingIcon,
    this.trailingIcon,
    this.trailingIconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sp(double v) => v * scale;
    double sz(double v) => v * scale;

    final radius = sz(16);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 🌊 Water animation
              Positioned.fill(
                child: LiquidLinearProgressIndicator(
                  value: fill.clamp(0.0, 1.0),
                  valueColor: AlwaysStoppedAnimation(
                    newBlue.withOpacity(0.75),
                  ),
                  backgroundColor: Colors.transparent,
                  borderWidth: 0,
                  borderColor: Colors.transparent,
                  direction: Axis.vertical,
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(sz(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((topLabel ?? '').isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              topLabel!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: sp(13),
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                          if (leadingIcon != null)
                            Icon(
                              leadingIcon,
                              size: sz(18),
                              color: Colors.black.withOpacity(0.55),
                            ),
                          if (trailingIcon != null) ...[
                            SizedBox(width: sz(6)),
                            Icon(
                              trailingIcon,
                              size: sz(18),
                              color: trailingIconColor ??
                                  Colors.black.withOpacity(0.55),
                            ),
                          ],
                        ],
                      )
                    else
                      SizedBox(height: sz(10)),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: sp(16),
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: sz(10)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subtitle1,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: sp(13),
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.65),
                            ),
                          ),
                          if (subtitle2.isNotEmpty)
                            Text(
                              subtitle2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: sp(13),
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.65),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
