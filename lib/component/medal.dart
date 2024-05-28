import 'package:flutter/material.dart';

class Medal extends StatelessWidget {
  final int rank;
  Medal({
    super.key,
    required this.rank
  });

  final List<Color> colors = [
    const Color(0xFFD4AF37),
    const Color(0xFFBCC6CC),
    const Color(0xFF49371B),
    const Color(0xFFA19D94),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors[rank-1],
      ),
      child: Center(
        child: Text(
          rank.toString(),
          style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
      )
    );
  }
}
