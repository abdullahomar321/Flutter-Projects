import 'package:flutter/material.dart';

class DraggableAddButton extends StatefulWidget {
  final VoidCallback onPressed;

  const DraggableAddButton({super.key, required this.onPressed});

  @override
  State<DraggableAddButton> createState() => _DraggableAddButtonState();
}

class _DraggableAddButtonState extends State<DraggableAddButton> {
  Offset position = const Offset(300, 600);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Draggable(
            feedback: buildButton(),
            childWhenDragging: const SizedBox.shrink(),
            onDragEnd: (details) {
              setState(() {
                position = details.offset;
              });
            },
            child: GestureDetector(
              onTap: widget.onPressed,
              child: buildButton(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: const Icon(Icons.add, color: Colors.white, size: 30),
    );
  }
}
