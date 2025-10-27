import 'package:flutter/material.dart';
import '../models/game_controller.dart';
import '../models/game_board.dart';

class GameBoardWidget extends StatefulWidget {
  final GameController controller;

  const GameBoardWidget({super.key, required this.controller});

  @override
  State<GameBoardWidget> createState() => _GameBoardWidgetState();
}

class _GameBoardWidgetState extends State<GameBoardWidget> {
  int? hoveredRow;
  int? hoveredCol;
  Block? draggedBlock;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Block>(
      onWillAccept: (block) {
        return block != null;
      },
      onAcceptWithDetails: (details) {
        if (draggedBlock != null && hoveredRow != null && hoveredCol != null) {
          bool success = widget.controller.tryPlaceBlockWithDrag(
            draggedBlock!,
            hoveredRow!,
            hoveredCol!,
          );
          if (success) {
            setState(() {
              hoveredRow = null;
              hoveredCol = null;
              draggedBlock = null;
            });
          }
        }
      },
      onMove: (details) {
        _updateHoverPosition(details.offset);
      },
      onLeave: (data) {
        setState(() {
          hoveredRow = null;
          hoveredCol = null;
          draggedBlock = null;
        });
      },
      builder: (context, candidateData, rejectedData) {
        if (candidateData.isNotEmpty) {
          draggedBlock = candidateData.first;
        }

        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double cellSize = (constraints.maxWidth - 18) / 10; // 패딩과 간격 고려

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: 100,
                itemBuilder: (context, index) {
                  int row = index ~/ 10;
                  int col = index % 10;
                  bool isFilled = widget.controller.board.grid[row][col];
                  bool canPlace = draggedBlock != null
                      ? widget.controller.canPlaceBlockAt(
                          draggedBlock!,
                          row,
                          col,
                        )
                      : widget.controller.canPlaceAtPosition(row, col);

                  bool isHovered = hoveredRow == row && hoveredCol == col;
                  bool isInDragPreview = false;

                  // 드래그 중인 블록의 미리보기 표시
                  if (draggedBlock != null &&
                      hoveredRow != null &&
                      hoveredCol != null) {
                    for (int i = 0; i < draggedBlock!.shape.length; i++) {
                      for (int j = 0; j < draggedBlock!.shape[i].length; j++) {
                        if (draggedBlock!.shape[i][j] &&
                            row == hoveredRow! + i &&
                            col == hoveredCol! + j) {
                          isInDragPreview = true;
                          break;
                        }
                      }
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      widget.controller.tryPlaceBlock(row, col);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isFilled
                            ? Colors.blue[600]
                            : isInDragPreview
                            ? (canPlace ? Colors.green[400] : Colors.red[400])
                            : canPlace &&
                                  widget.controller.selectedBlock != null
                            ? Colors.green[200]
                            : Colors.white,
                        border: Border.all(
                          color: isHovered ? Colors.orange : Colors.grey[400]!,
                          width: isHovered ? 2.0 : 0.5,
                        ),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _updateHoverPosition(Offset position) {
    // 보드 위젯의 RenderBox를 가져와서 로컬 좌표로 변환
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(position);

    // 패딩 고려
    final adjustedX = localPosition.dx - 8;
    final adjustedY = localPosition.dy - 8;

    if (adjustedX >= 0 && adjustedY >= 0) {
      final cellSize = (renderBox.size.width - 18) / 10; // 패딩과 간격 고려

      int col = (adjustedX / (cellSize + 1)).floor();
      int row = (adjustedY / (cellSize + 1)).floor();

      if (col >= 0 && col < 10 && row >= 0 && row < 10) {
        setState(() {
          hoveredRow = row;
          hoveredCol = col;
        });
      }
    }
  }
}
