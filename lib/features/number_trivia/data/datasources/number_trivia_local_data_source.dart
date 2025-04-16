// ignore_for_file: constant_identifier_names

import 'dart:convert';

import '../models/number_trivia_model.dart';
import '../../../../core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten last time
  /// the user had an internet connection
  ///
  /// Throws [CacheException] if no cached data is present.

  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    final jsonString = json.encode(triviaToCache.tojson());
    await sharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonString);
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
