import 'package:flutter/material.dart';
import '../models/game_board.dart';
import '../models/game_controller.dart';

class BlockWidget extends StatelessWidget {
  final Block block;
  final GameController controller;
  final bool isSelected;

  const BlockWidget({
    super.key,
    required this.block,
    required this.controller,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<Block>(
      data: block,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 0.8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange[300],
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8.0),
            child: _buildBlockGrid(isDragging: true),
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: _buildBlockContainer()),
      child: GestureDetector(
        onTap: () {
          if (isSelected) {
            controller.deselectBlock();
          } else {
            controller.selectBlock(block);
          }
        },
        child: _buildBlockContainer(),
      ),
    );
  }

  Widget _buildBlockContainer() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange[200] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: isSelected ? Colors.orange : Colors.grey,
          width: 2.0,
        ),
      ),
      child: _buildBlockGrid(),
    );
  }

  Widget _buildBlockGrid({bool isDragging = false}) {
    int maxCellSize = isDragging ? 15 : 20;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: block.shape.map((row) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: row.map((cell) {
            return Container(
              width: maxCellSize.toDouble(),
              height: maxCellSize.toDouble(),
              margin: const EdgeInsets.all(0.5),
              decoration: BoxDecoration(
                color: cell ? Colors.blue[600] : Colors.transparent,
                borderRadius: BorderRadius.circular(2.0),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
