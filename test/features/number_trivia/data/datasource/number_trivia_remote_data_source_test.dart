import 'dart:convert';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../fixtures/fixture_read.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDatasourceImpl remoteDataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    remoteDataSource = NumberTriviaRemoteDatasourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(
      mockHttpClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailer404() {
    when(
      mockHttpClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia.json')),
    );
    test(
      '''should perform a Get request on URL with number
       being the endpoint and with application/json header''',
      () async {
        //arrange
        setUpMockHttpClientSuccess200();
        //act
        await remoteDataSource.getConcreteNumberTrivia(tNumber);
        //assert
        verify(
          mockHttpClient.get(
            Uri.parse('http://numberapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should return NumberTrivia when the respose code is 200(success)',
      () async {
        //arrange
        setUpMockHttpClientSuccess200();
        //act
        final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);
        //assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      '''should throw a ServerException when the response code is 404 or other''',
      () async {
        //arrange
        setUpMockHttpClientFailer404();
        //act
        final call = remoteDataSource.getConcreteNumberTrivia;
        //assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia.json')),
    );
    test(
      '''should perform a Get request on the URL
     with random being the endpoint and with application/json header''',
      () async {
        //arrange
        setUpMockHttpClientSuccess200();
        //act
        remoteDataSource.getRandomNumberTriva();
        //assert
        verify(
          mockHttpClient.get(
            Uri.parse('http://numberapi.com/random'),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );
    test('should return NumberTrivia when the response code is 200', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await remoteDataSource.getRandomNumberTriva();
      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw ServerException when the respons code is 404', () async {
      //arrange
      setUpMockHttpClientFailer404();
      //act
      final call = remoteDataSource.getRandomNumberTriva;
      //assert
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
