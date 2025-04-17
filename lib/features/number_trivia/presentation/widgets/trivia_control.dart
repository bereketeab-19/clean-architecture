import '../bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({super.key});

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  late String inputStr;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          onChanged: (value) {
            inputStr = value;
          },
          keyboardType: TextInputType.numberWithOptions(),
          onSubmitted: (_) => dispatchConcrete(),
          decoration: InputDecoration(
            hintText: 'Input a number',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey.shade500),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: dispatchConcrete,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(),
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                ),
                child: Text('Search trivia'),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: dispatchRandom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(),
                ),
                child: Text('Get random Trivia'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(
      context,
    ).add(GetTriviaFromConcreteNumber(numberString: inputStr));
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaFromRandomNumber());
  }
}
