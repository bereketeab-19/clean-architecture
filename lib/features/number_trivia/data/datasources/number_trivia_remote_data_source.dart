import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/number_trivia_model.dart';
import '../../../../core/error/exceptions.dart';


abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint
  ///
  /// Throw a[ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint
  ///
  /// Throw a[ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTriva();
}

class NumberTriviaRemoteDatasourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDatasourceImpl({required this.client});
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    Uri url = Uri.parse("http://numberapi.com/$number");
    return _getTriviaFromUrl(url);
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTriva() async {
    Uri url = Uri.parse('http://numberapi.com/random');
    return _getTriviaFromUrl(url);
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(Uri url) async {
    Map<String, String> header = {'Content-Type': 'application/json'};

    return await client.get(url, headers: header).then((response) {
      if (response.statusCode == 200) {
        return NumberTriviaModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException();
      }
    });
  }
}
