import '../models/number_trivia_model.dart';
import 'package:clean_architecture/core/error/exceptions.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint
  ///
  /// Throw a[ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTriva();
}
