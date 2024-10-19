import 'package:fchess/src/components/piece.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final Piece? piece;
  final bool isHighlighted;
  const Square(
      {super.key,
      required this.isWhite,
      required this.piece,
      required this.isHighlighted});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isWhite ? const Color.fromARGB(255, 205, 179, 209) : const Color.fromARGB(255, 142, 74, 161),
        border: isHighlighted
            ? Border.all(
                color: Colors.green, width: 3) // Border color and width
            : null, // No border if not highlighted
      ),
      child: piece != null ? Image.asset(piece!.getPieceFace()) : null,
    );
  }
}
