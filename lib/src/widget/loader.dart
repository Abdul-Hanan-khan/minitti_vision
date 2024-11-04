import 'package:flutter/material.dart';

class RippleAnimation extends StatefulWidget {
  final Color color;
  final double size; // Maximum size of the ripples
  final double lineWidth; // Thickness of the ripples
  final bool loading;
        Widget? centerWidget;

   RippleAnimation({
    Key? key,
    this.color = Colors.blue,
    this.size = 150.0, // Increased default size
    this.lineWidth = 6.0, // Increased line width
    this.loading =false,
    this.centerWidget
  }) : super(key: key);

  @override
  _RippleAnimationState createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<RippleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    ); // Repeat animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildRipple(double delayFactor) {

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = (_controller.value + delayFactor) % 1.0;
        return Container(
          width: widget.size * progress, // Use the size parameter
          height: widget.size * progress, // Use the size parameter
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.color.withOpacity(1 - progress),
              width: widget.lineWidth, // Use the lineWidth parameter
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if(widget.loading){
      _controller.repeat();
    }else{
      _controller.stop();
    }
    return SizedBox(
      width: 200,
      height: 200,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // The ripple animations
            _buildRipple(0.0),   // First ripple
            _buildRipple(0.33),  // Second ripple, delayed
            _buildRipple(0.66),  // Third ripple, further delayed
            _buildRipple(0.66),  // Third ripple, further delayed
            _buildRipple(0.66),  // Third ripple, further delayed

            // Your centered widget
           widget.centerWidget?? Container(
              width: 50.0, // Width of your central widget
              height: 50.0, // Height of your central widget
             decoration: BoxDecoration(shape: BoxShape.circle),
              child: Center(
                child: Text(
                  'Center', // Text or other widget
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
