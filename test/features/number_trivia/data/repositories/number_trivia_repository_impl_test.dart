import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/platform/network_info.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([
  NumberTriviaRemoteDataSource,
  NumberTriviaLocalDataSource,
  NetworkInfo,
])
void main() {
  late NumberTriviaRepositoryImpl repositoryImpl;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'test trivia',
      number: tNumber,
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel); 
      //act
      await repositoryImpl.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is onlice', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'shoud return remote data when the call to remote data source is successful',
        () async {
          //arrange
          when(
            mockRemoteDataSource.getConcreteNumberTrivia(any),
          ).thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'shoud cache data locally when the call to remote data source is successful',
        () async {
          //arrange
          when(
            mockRemoteDataSource.getConcreteNumberTrivia(any),
          ).thenAnswer((_) async => tNumberTriviaModel);
          //act
          await repositoryImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'shoud return server failure when the call to remote data source is unsuccessful',
        () async {
          //arrange
          when(
            mockRemoteDataSource.getConcreteNumberTrivia(any),
          ).thenThrow(ServerException());
          //act
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
        'should return cache failure when there is no cached data is present',
        ()async {
          //arrange
          when(
            mockLocalDataSource.getLastNumberTrivia(),
          ).thenThrow(CacheException());
          //act
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
      
       test(
        'should return the locally cached data when cached data is present',
        ()async {
          //arrange
          when(
            mockLocalDataSource.getLastNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
    });
  });


  group('getRandomNumberTrivia', () {
    
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'test trivia',
      number: 123,
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getRandomNumberTriva())
          .thenAnswer((_) async => tNumberTriviaModel); 
      //act
      await repositoryImpl.getRandomNumberTrivia();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'shoud return remote data when the call to remote data source is successful',
        () async {
          //arrange
          when(
            mockRemoteDataSource.getRandomNumberTriva(),
          ).thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repositoryImpl.getRandomNumberTrivia();
          //assert
          verify(mockRemoteDataSource.getRandomNumberTriva());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'shoud cache data locally when the call to remote data source is successful',
        () async {
          //arrange
          when(
            mockRemoteDataSource.getRandomNumberTriva(),
          ).thenAnswer((_) async => tNumberTriviaModel);
          //act
          await repositoryImpl.getRandomNumberTrivia();
          //assert
          verify(mockRemoteDataSource.getRandomNumberTriva());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'shoud return server failure when the call to remote data source is unsuccessful',
        () async {
          //arrange
          when(
            mockRemoteDataSource.getRandomNumberTriva(),
          ).thenThrow(ServerException());
          //act
          final result = await repositoryImpl.getRandomNumberTrivia();
          //assert
          verify(mockRemoteDataSource.getRandomNumberTriva());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
        'should return cache failure when there is no cached data is present',
        ()async {
          //arrange
          when(
            mockLocalDataSource.getLastNumberTrivia(),
          ).thenThrow(CacheException());
          //act
          final result = await repositoryImpl.getRandomNumberTrivia();
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
      
       test(
        'should return the locally cached data when cached data is present',
        ()async {
          //arrange
          when(
            mockLocalDataSource.getLastNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repositoryImpl.getRandomNumberTrivia();
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
    });
  });
}
