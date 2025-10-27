import 'dart:math';

class GameBoard {
  static const int size = 10;
  late List<List<bool>> grid;
  int score = 0;

  GameBoard() {
    reset();
  }

  void reset() {
    grid = List.generate(size, (i) => List.generate(size, (j) => false));
    score = 0;
  }

  bool canPlaceBlock(Block block, int row, int col) {
    for (int i = 0; i < block.shape.length; i++) {
      for (int j = 0; j < block.shape[i].length; j++) {
        if (block.shape[i][j]) {
          int newRow = row + i;
          int newCol = col + j;

          // 경계 체크
          if (newRow >= size || newCol >= size || newRow < 0 || newCol < 0) {
            return false;
          }

          // 이미 채워진 셀 체크
          if (grid[newRow][newCol]) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void placeBlock(Block block, int row, int col) {
    for (int i = 0; i < block.shape.length; i++) {
      for (int j = 0; j < block.shape[i].length; j++) {
        if (block.shape[i][j]) {
          grid[row + i][col + j] = true;
        }
      }
    }

    // 점수 추가
    score += block.getSize();

    // 완성된 줄 제거
    clearCompletedLines();
  }

  void clearCompletedLines() {
    int clearedLines = 0;

    // 가로줄 체크
    for (int row = 0; row < size; row++) {
      bool isComplete = true;
      for (int col = 0; col < size; col++) {
        if (!grid[row][col]) {
          isComplete = false;
          break;
        }
      }
      if (isComplete) {
        for (int col = 0; col < size; col++) {
          grid[row][col] = false;
        }
        clearedLines++;
      }
    }

    // 세로줄 체크
    for (int col = 0; col < size; col++) {
      bool isComplete = true;
      for (int row = 0; row < size; row++) {
        if (!grid[row][col]) {
          isComplete = false;
          break;
        }
      }
      if (isComplete) {
        for (int row = 0; row < size; row++) {
          grid[row][col] = false;
        }
        clearedLines++;
      }
    }

    // 완성된 줄 보너스 점수
    if (clearedLines > 0) {
      score += clearedLines * 10;
    }
  }

  bool hasValidMove(List<Block> availableBlocks) {
    for (Block block in availableBlocks) {
      for (int row = 0; row < size; row++) {
        for (int col = 0; col < size; col++) {
          if (canPlaceBlock(block, row, col)) {
            return true;
          }
        }
      }
    }
    return false;
  }
}

class Block {
  final List<List<bool>> shape;
  final int id;

  Block(this.shape, this.id);

  int getSize() {
    int size = 0;
    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        if (shape[i][j]) size++;
      }
    }
    return size;
  }

  static List<Block> generateRandomBlocks() {
    List<List<List<bool>>> blockShapes = [
      // 1x1 정사각형
      [
        [true],
      ],

      // 2x2 정사각형
      [
        [true, true],
        [true, true],
      ],

      // 3x3 정사각형
      [
        [true, true, true],
        [true, true, true],
        [true, true, true],
      ],

      // 1x2 가로
      [
        [true, true],
      ],

      // 1x3 가로
      [
        [true, true, true],
      ],

      // 1x4 가로
      [
        [true, true, true, true],
      ],

      // 1x5 가로
      [
        [true, true, true, true, true],
      ],

      // 2x1 세로
      [
        [true],
        [true],
      ],

      // 3x1 세로
      [
        [true],
        [true],
        [true],
      ],

      // 4x1 세로
      [
        [true],
        [true],
        [true],
        [true],
      ],

      // 5x1 세로
      [
        [true],
        [true],
        [true],
        [true],
        [true],
      ],

      // L 모양 (왼쪽)
      [
        [true, false],
        [true, false],
        [true, true],
      ],

      // L 모양 (오른쪽)
      [
        [false, true],
        [false, true],
        [true, true],
      ],

      // T 모양
      [
        [true, true, true],
        [false, true, false],
      ],

      // 작은 L (왼쪽)
      [
        [true, false],
        [true, true],
      ],

      // 작은 L (오른쪽)
      [
        [false, true],
        [true, true],
      ],

      // 계단 모양 (왼쪽)
      [
        [true, true, false],
        [false, true, true],
      ],

      // 계단 모양 (오른쪽)
      [
        [false, true, true],
        [true, true, false],
      ],

      // 십자 모양
      [
        [false, true, false],
        [true, true, true],
        [false, true, false],
      ],
    ];

    final random = Random();
    List<Block> blocks = [];
    List<int> availableIndices = List.generate(
      blockShapes.length,
      (index) => index,
    );

    for (int i = 0; i < 3; i++) {
      if (availableIndices.isEmpty) {
        availableIndices = List.generate(blockShapes.length, (index) => index);
      }

      int randomIndex = random.nextInt(availableIndices.length);
      int shapeIndex = availableIndices.removeAt(randomIndex);
      blocks.add(Block(blockShapes[shapeIndex], i));
    }

    return blocks;
  }
}
