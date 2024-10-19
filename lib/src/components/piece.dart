enum Type {king, queen, rook, bishop, knight, pawn}

class Piece {
  final bool isWhite;
  final Type type;

  Piece({
    required this.isWhite,
    required this.type,
  });

  String getPieceFace() {
    String fileName;

    switch (type) {
      case Type.king:
        fileName = isWhite ? 'K.png' : 'kk.png';
        break;
      case Type.queen:
        fileName = isWhite ? 'Q.png' : 'qq.png';
        break;
      case Type.rook:
        fileName = isWhite ? 'R.png' : 'rr.png';
        break;
      case Type.bishop:
        fileName = isWhite ? 'B.png' : 'bb.png';
        break;
      case Type.knight:
        fileName = isWhite ? 'N.png' : 'nn.png';
        break;
      case Type.pawn:
        fileName = isWhite ? 'P.png' : 'pp.png';
        break;
    }

    return 'lib/src/assets/$fileName'; // Return the full path to the image
  }
}