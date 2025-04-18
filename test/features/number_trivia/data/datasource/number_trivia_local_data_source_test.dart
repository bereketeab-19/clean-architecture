import 'dart:convert';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_read.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late NumberTriviaLocalDataSourceImpl dataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia_cached.json')),
    );
    test(
      'should return NumberTrivia from sharedPreference when there is one in the cache',
      () async {
        // arrange
        when(
          mockSharedPreferences.getString(any),
        ).thenReturn(fixture('trivia_cached.json'));
        //act
        final result = await dataSourceImpl.getLastNumberTrivia();
        //assert
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'should throw a CacheExecption when there is not a cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        //act
        final call = dataSourceImpl.getLastNumberTrivia;
        //assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('CacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(
      number: 1,
      text: 'test trivia',
    );
    test('should call sharedPreferences to cache the data', () async {
      //arrange
      when(
        mockSharedPreferences.setString(any, any),
      ).thenAnswer((_) async => true);
      //act
      dataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
      //assert
      final expectedJsonString = json.encode(tNumberTriviaModel.tojson());
      verify(
        mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA,
          expectedJsonString,
        ),
      );
    });
  });
}
