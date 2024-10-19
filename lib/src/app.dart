import 'package:fchess/src/components/piece.dart';
import 'package:fchess/src/components/square.dart';
import 'package:flutter/material.dart';

class Chess extends StatefulWidget {
  const Chess({super.key});

  @override
  State<Chess> createState() => _ChessState();
}

class _ChessState extends State<Chess> {
  int selectedRow = -1;
  int selectedCol = -1;
  List<List<dynamic>> generatedMoves = [];
  List<List<Piece?>> board = []; // Move board initialization here


  @override
  void initState() {
    super.initState();
    String fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR';
    board = generateBoardFromFEN(fen); // Initialize board here
  }

  List<List<Piece?>> generateBoardFromFEN(String fen) {
    final piecePlacement = fen.split(' ')[0];

    List<List<Piece?>> board = List.generate(8, (_) => List.filled(8, null));

    List<String> ranks = piecePlacement.split('/');

    for (int rankIndex = 0; rankIndex < ranks.length; rankIndex++) {
      String rank = ranks[rankIndex];
      int fileIndex = 0;

      for (int charIndex = 0; charIndex < rank.length; charIndex++) {
        String char = rank[charIndex];

        if (int.tryParse(char) != null) {
          int emptyCount = int.parse(char);
          fileIndex += emptyCount; // Skip empty squares
        } else {
          bool isWhite = char.toUpperCase() == char;
          Type pieceType;

          switch (char.toLowerCase()) {
            case 'k':
              pieceType = Type.king;
              break;
            case 'q':
              pieceType = Type.queen;
              break;
            case 'r':
              pieceType = Type.rook;
              break;
            case 'b':
              pieceType = Type.bishop;
              break;
            case 'n':
              pieceType = Type.knight;
              break;
            case 'p':
              pieceType = Type.pawn;
              break;
            default:
              continue;
          }

          board[7 - rankIndex][fileIndex] =
              Piece(isWhite: isWhite, type: pieceType);
          fileIndex++;
        }
      }
    }

    return board;
  }

  List<List<dynamic>> getAvailableMoves(int row, int col, List<List<Piece?>> board) {

    if (board[row][col] == null) return [];

    Type pieceType = board[row][col]!.type;

    List<List<dynamic>> availableMoves = [];
    bool isWhite = board[row][col]!.isWhite;

    print(pieceType);

    List<List<int>> directions = [];
    switch (pieceType) {
      case Type.rook:
        directions = [
          [1, 0],
          [-1, 0],
          [0, 1],
          [0, -1]
        ];
        break;
      case Type.bishop:
        directions = [
          [1, 1],
          [1, -1],
          [-1, 1],
          [-1, -1]
        ];
        break;
      case Type.queen:
        directions = [
          [1, 0],
          [-1, 0],
          [0, 1],
          [0, -1],
          [1, 1],
          [1, -1],
          [-1, 1],
          [-1, -1]
        ];
        break;
      case Type.king:
        directions = [
          [1, 0],
          [-1, 0],
          [0, 1],
          [0, -1],
          [1, 1],
          [1, -1],
          [-1, 1],
          [-1, -1]
        ];
        break;
      case Type.knight:
        directions = [
          [2, 1],
          [2, -1],
          [-2, 1],
          [-2, -1],
          [1, 2],
          [1, -2],
          [-1, 2],
          [-1, -2]
        ];
        break;
      case Type.pawn:
        if (!isWhite) {
          print(row);
          print(col);
          print(board[row - 1][col]);
          // White Pawn Movement
          if (row > 0 && board[row - 1][col] == null) {
            availableMoves.add([row - 1, col, false]); // Move forward
          }
          if (row == 6 &&
              board[row - 1][col] == null &&
              board[row - 2][col] == null) {
            availableMoves.add(
                [row - 2, col, false]); // Double move from initial position
          }
          if (col > 0 && row > 0 && board[row - 1][col - 1]?.isWhite == false) {
            availableMoves.add([row - 1, col - 1, true]); // Capture left
          }
          if (col < 7 && row > 0 && board[row - 1][col + 1]?.isWhite == false) {
            availableMoves.add([row - 1, col + 1, true]); // Capture right
          }
        } else {
          // Black Pawn Movement
          if (row < 7 && board[row + 1][col] == null) {
            availableMoves.add([row + 1, col, false]); // Move forward
          }
          if (row == 1 &&
              board[row + 1][col] == null &&
              board[row + 2][col] == null) {
            availableMoves.add(
                [row + 2, col, false]); // Double move from initial position
          }
          if (col > 0 && row < 7 && board[row + 1][col - 1]?.isWhite == true) {
            availableMoves.add([row + 1, col - 1, true]); // Capture left
          }
          if (col < 7 && row < 7 && board[row + 1][col + 1]?.isWhite == true) {
            availableMoves.add([row + 1, col + 1, true]); // Capture right
          }
        }
        // print(availableMoves[0][0]);
        return availableMoves;
    }
    
    for (List<int> direction in directions) {
      bool isKnight = pieceType == Type.knight;
      int knightCount = 0;
      int r = row, c = col;
      while (true) {
        r += direction[0];
        c += direction[1];
        if (r < 0 || r >= 8 || c < 0 || c >= 8 || (isKnight && knightCount > 0)) break;

        Piece? targetPiece = board[r][c];
        if (targetPiece == null) {
          availableMoves.add([r, c, false]);
          knightCount++;
        } else {
          if (targetPiece.isWhite != isWhite) {
            availableMoves.add([r, c, true]);
            knightCount++;
          }
          break;
        }
      }
    }

    print(availableMoves[0][0]);

    return availableMoves;
  }

  void selectSquare(int row, int col, List<List<Piece?>> board) {
    bool available = generatedMoves.any((move) => move[0] == row && move[1] == col);
    if (available) {
    // Move the piece
    setState(() {
      // Move the selected piece to the new position
      board[row][col] = board[selectedRow][selectedCol];
      board[selectedRow][selectedCol] = null; // Clear the previous position

      // Reset the selected row and column
      selectedRow = -1;
      selectedCol = -1;

      // Clear generated moves after a successful move
      generatedMoves.clear();
    });
    } else {
      setState(() {
        selectedRow = row;
        selectedCol = col;
        generatedMoves =
            getAvailableMoves(row, col, board);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("❤️"),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 64,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                itemBuilder: (context, index) {
                  final int row = index ~/ 8;
                  final int rowCell = index % 2;
                  final int col = index % 8;
                  final bool isEvenRow =
                      row % 2 == 0; // Determines if it's an even row
                  final bool isEvenIndex = rowCell == 0;
                  final bool isWhite =
                      (isEvenRow && isEvenIndex) || (!isEvenRow && !isEvenIndex)
                          ? true
                          : false;

                  bool isHighlighted = generatedMoves != null
                      ? generatedMoves
                          .any((move) => move[0] == row && move[1] == col)
                      : false;

                  return GestureDetector(
                    onTap: () => selectSquare(row, col, board),
                    child: Square(
                        isWhite: isWhite,
                        piece: board[row][col],
                        isHighlighted: isHighlighted),
                  );
                },
              ),
            ),
            const Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("❤️")],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
