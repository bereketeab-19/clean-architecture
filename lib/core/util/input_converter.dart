import '../error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failures, int> stringToUnsignedInteger(String str) {
    try {
      final intValue = int.parse(str);
      if (intValue < 0) throw FormatException();
      return Right(intValue);
    } catch (e) {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failures {}

