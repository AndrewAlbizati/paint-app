import 'package:flutter/material.dart';
import 'package:paint_app/drawing_painter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DrawingBoard(),
    );
  }
}

/// This Widget contains the user interface as well as some of the logic
/// For the canvas and the color picker
class DrawingBoard extends StatefulWidget {
  @override
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  Color selectedColor = Colors.black; // Default color of the user's pen
  double strokeWidth = 10; // Default width of the user's pen
  List<DrawingPoint?> drawingPoints = []; // List of points the user has colored
  // Create list of colors available to the user
  List<Color> colors = [
    Colors.black,
    const Color.fromARGB(255, 255, 17, 0),
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.green,
    const Color.fromARGB(255, 250, 250, 250),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Paint App',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              // When panning, add points to the drawingPoints list
              onPanStart: (details) => setState(
                () => drawingPoints.add(
                  DrawingPoint(
                    details.localPosition,
                    Paint()
                      ..color = selectedColor
                      ..isAntiAlias = true
                      ..strokeWidth = strokeWidth
                      ..strokeCap = StrokeCap.round,
                  ),
                ),
              ),
              onPanUpdate: (details) => setState(
                () => drawingPoints.add(
                  DrawingPoint(
                    details.localPosition,
                    Paint()
                      ..color = selectedColor
                      ..isAntiAlias = true
                      ..strokeWidth = strokeWidth
                      ..strokeCap = StrokeCap.round,
                  ),
                ),
              ),
              // Add null to signify that the pan has ended
              onPanEnd: (details) => setState(() => drawingPoints.add(null)),
              child: CustomPaint(
                painter: DrawingPainter(drawingPoints),
                child: Container(),
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Slider for pen thickness
                Slider(
                  min: 10,
                  max: 30,
                  value: strokeWidth,
                  onChanged: (val) => setState(() => strokeWidth = val),
                ),
                // Erase button
                ElevatedButton.icon(
                  onPressed: () => setState(() => drawingPoints = []),
                  icon: Icon(Icons.clear),
                  label: Text('Clear'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.grey[200],
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // Create list of color picker widgets
            children: List.generate(
              colors.length,
              (index) => _buildColorPicker(colors[index]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        // Make picker larger if selected
        height: isSelected ? 47 : 40,
        width: isSelected ? 47 : 40,
        // Add black border if selected
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
        ),
      ),
    );
  }
}
