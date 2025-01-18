import 'package:flutter/material.dart';

class BabeczkaWidget extends StatefulWidget {
  const BabeczkaWidget({super.key, required this.scale});

  final double scale;

  @override
  State<BabeczkaWidget> createState() => _BabeczkaWidgetState();
}

class _BabeczkaWidgetState extends State<BabeczkaWidget> {
  int spacing = 0;

  @override
  void initState() {
    animateSpacing();
    super.initState();
  }

  void animateSpacing() {
    Future<void> animate() async {
      while (true) {
        for (int i = 0; i <= 4; i++) {
          await Future.delayed(const Duration(milliseconds: 100));
          setState(() {
            spacing = i;
          });
        }
        for (int i = 4; i >= 0; i--) {
          await Future.delayed(const Duration(milliseconds: 100));
          setState(() {
            spacing = i;
          });
        }
      }
    }

    animate();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.scale,
      child: SizedBox(
        height: 402,
        width: 584,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/app/doctor.png',
              width: 584,
              fit: BoxFit.contain,
            ),
            Positioned(
                top: 88,
                left: MediaQuery.of(context).size.width / 2 - 12,
                child: Image.asset(
                  'assets/images/app/lipBackground.png',
                  height: 20,
                  width: 30,
                )),
            Positioned(
              top: 88,
              left: MediaQuery.of(context).size.width / 2 - 12,
              child: SizedBox(
                height: 40,
                width: 30,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/app/upperLip.png',
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: spacing.toDouble()),
                    Image.asset(
                      'assets/images/app/lowerLip.png',
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
