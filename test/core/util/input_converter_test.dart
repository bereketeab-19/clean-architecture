// import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('StringToUnsignedInt', () {
    test(
      'should return integer when the string represents an unsigned integer',
      () async {
        //arrange
        final str = '123';
        //act
        final result = inputConverter.stringToUnsignedInteger(str);
        //assert
        expect(result, Right(123));
      },
    );
    test('should return a Failure when the string is not an integer', () async {
      //arrange
      final str = 'abc';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, equals(Left(InvalidInputFailure())));
    });

     test('should return a Failure when the string is a negative integer', () async {
      //arrange
      final str = '-123';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, equals(Left(InvalidInputFailure())));
    });
  });
}
