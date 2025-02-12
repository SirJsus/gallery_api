import 'package:flutter/material.dart';

class AnimatedScreen extends StatefulWidget {
  @override
  State<AnimatedScreen> createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen> {
  double _width = 100;
  double _height = 100;
  Color _color = Colors.blue;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(10);

  void _changeShape() {
    setState(() {
      _width = _width == 200 ? 300 : 200;
      _height = _height == 200 ? 300 : 200;
      _color = _color == Colors.blue ? Colors.red : Colors.blue;
      _borderRadius = _borderRadius == BorderRadius.circular(10)
          ? BorderRadius.circular(50)
          : BorderRadius.circular(10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated Container'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: _borderRadius,
              ),
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _changeShape();
              },
              child: Text('Cambiar de forma'),
            ),
          ],
        ),
      ),
    );
  }
}
