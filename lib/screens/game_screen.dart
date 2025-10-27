import 'package:flutter/material.dart';
import '../models/game_controller.dart';
import '../widgets/game_board_widget.dart';
import '../widgets/block_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GameController();
    _controller.addListener(_onGameStateChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onGameStateChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onGameStateChanged() {
    setState(() {});

    if (_controller.gameOver) {
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('게임 오버!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('더 이상 놓을 수 있는 블록이 없습니다.'),
              const SizedBox(height: 10),
              Text(
                '최종 점수: ${_controller.board.score}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _controller.startNewGame();
              },
              child: const Text('다시 시작'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1010! 게임'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              _controller.startNewGame();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // 점수 표시
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          '점수: ${_controller.board.score}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 게임 보드 - 반응형 크기
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth - 32,
                          maxHeight: constraints.maxHeight * 0.6,
                        ),
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: GameBoardWidget(controller: _controller),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 드래그 안내 텍스트
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: const Text(
                          '💡 블록을 터치하거나 드래그해서 보드에 놓으세요!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.orange,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 사용 가능한 블록들 - 오버플로우 방지
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxHeight: constraints.maxHeight * 0.25,
                          minHeight: 120,
                        ),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '사용 가능한 블록',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: _controller.availableBlocks.map((
                                  block,
                                ) {
                                  bool isSelected =
                                      _controller.selectedBlock == block;
                                  return Flexible(
                                    flex: 1,
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 120,
                                        maxHeight: 100,
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: BlockWidget(
                                          block: block,
                                          controller: _controller,
                                          isSelected: isSelected,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
