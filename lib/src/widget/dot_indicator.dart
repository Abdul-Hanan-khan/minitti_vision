import 'package:flutter/material.dart';


class DotIndicators extends StatefulWidget {
  final Color color;
  final double dotSize; // Size of the dots
  final double dotSpacing; // Spacing between the dots

  const DotIndicators({
    Key? key,
    this.color = Colors.blue,
    this.dotSize = 10.0,
    this.dotSpacing = 5.0,
  }) : super(key: key);

  @override
  _DotIndicatorsState createState() => _DotIndicatorsState();
}

class _DotIndicatorsState extends State<DotIndicators>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true); // Repeat the animation

    _dotAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index / 3.0, // Start time
            (index + 1) / 3.0, // End time
            curve: Curves.easeInOut, // Animation curve
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _dotAnimations[index],
          builder: (context, child) {
            return Opacity(
              opacity: _dotAnimations[index].value,
              child: Container(
                width: widget.dotSize,
                height: widget.dotSize,
                margin: EdgeInsets.symmetric(horizontal: widget.dotSpacing / 2), // Half the spacing for even distribution
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
