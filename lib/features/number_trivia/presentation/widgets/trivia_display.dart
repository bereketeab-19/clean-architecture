import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter/material.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia trivia;
  const TriviaDisplay({super.key, required this.trivia});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(
            trivia.number.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(trivia.text, style: TextStyle(fontSize: 25)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
