import 'dart:convert';

import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_read.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');

  test('should be a subclass of NumberTrivia entity', () async {
    // assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test(
      'should return a valid model when the json number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(
          fixture('trivia.json'),
        );
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        //assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return a valid model when the json number is as a double',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(
          fixture('trivia_double.json'),
        );
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        //assert
        expect(result, tNumberTriviaModel);
      },
    );
  });

  group('toJson', () {
    test('should return a Json Map containing a proper data', () async {
      //act
      final result = tNumberTriviaModel.tojson();
      //assert
      final matcher = {'text': 'test text', 'number': 1};
      expect(result, matcher);
    });
  });
}
