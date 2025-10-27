import 'package:flutter/material.dart';
import 'game_board.dart';

class GameController extends ChangeNotifier {
  late GameBoard _board;
  late List<Block> _availableBlocks;
  Block? _selectedBlock;
  bool _gameOver = false;

  GameBoard get board => _board;
  List<Block> get availableBlocks => _availableBlocks;
  Block? get selectedBlock => _selectedBlock;
  bool get gameOver => _gameOver;

  GameController() {
    startNewGame();
  }

  void startNewGame() {
    _board = GameBoard();
    _availableBlocks = Block.generateRandomBlocks();
    _selectedBlock = null;
    _gameOver = false;
    notifyListeners();
  }

  void selectBlock(Block block) {
    _selectedBlock = block;
    notifyListeners();
  }

  void deselectBlock() {
    _selectedBlock = null;
    notifyListeners();
  }

  bool tryPlaceBlock(int row, int col) {
    if (_selectedBlock == null) return false;

    if (_board.canPlaceBlock(_selectedBlock!, row, col)) {
      _board.placeBlock(_selectedBlock!, row, col);

      // 사용된 블록 제거
      _availableBlocks.remove(_selectedBlock!);
      _selectedBlock = null;

      // 모든 블록이 사용되었으면 새로운 블록 생성
      if (_availableBlocks.isEmpty) {
        _availableBlocks = Block.generateRandomBlocks();
      }

      // 게임오버 체크 (성능 최적화를 위해 마지막에 실행)
      _checkGameOver();

      notifyListeners();
      return true;
    }

    return false;
  }

  bool tryPlaceBlockWithDrag(Block block, int row, int col) {
    if (_board.canPlaceBlock(block, row, col)) {
      _board.placeBlock(block, row, col);

      // 사용된 블록 제거
      _availableBlocks.remove(block);
      if (_selectedBlock == block) {
        _selectedBlock = null;
      }

      // 모든 블록이 사용되었으면 새로운 블록 생성
      if (_availableBlocks.isEmpty) {
        _availableBlocks = Block.generateRandomBlocks();
      }

      // 게임오버 체크
      _checkGameOver();

      notifyListeners();
      return true;
    }

    return false;
  }

  void _checkGameOver() {
    if (!_board.hasValidMove(_availableBlocks)) {
      _gameOver = true;
    }
  }

  bool canPlaceAtPosition(int row, int col) {
    if (_selectedBlock == null) return false;
    return _board.canPlaceBlock(_selectedBlock!, row, col);
  }

  bool canPlaceBlockAt(Block block, int row, int col) {
    return _board.canPlaceBlock(block, row, col);
  }
}
