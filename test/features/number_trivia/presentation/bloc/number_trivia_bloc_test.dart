import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  late NumberTriviaBloc bloc;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      converter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () async {
    //assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTriva = NumberTrivia(
      text: 'test trivia',
      number: tNumberParsed,
    );

    void setUpMockInputConverterSuccess() {
      when(
        mockInputConverter.stringToUnsignedInteger(any),
      ).thenReturn(Right(tNumberParsed));

      when(
        mockGetConcreteNumberTrivia.call(any),
      ).thenAnswer((_) async => Right(tNumberTriva));
    }

    test(
      'should call the InputConverter to validate and convert the String to unSigned integer',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        //act
        bloc.add(GetTriviaFromConcreteNumber(numberString: tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        //assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test('should emit [Error] when the input is invalid', () async {
      //arrange
      when(
        mockInputConverter.stringToUnsignedInteger(any),
      ).thenReturn(Left(InvalidInputFailure()));
      //assert later
      final expected = [
        Empty(),
        Error(errorMessege: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaFromConcreteNumber(numberString: tNumberString));
    });
    test('should get data from the concrete use case', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(
        mockGetConcreteNumberTrivia(any),
      ).thenAnswer((_) async => Right(tNumberTriva));
      //act
      bloc.add(GetTriviaFromConcreteNumber(numberString: tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      //assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });
    test(
      'should emit [Loading, Loaded] when data is gotten succesfully',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        when(
          mockGetConcreteNumberTrivia(any),
        ).thenAnswer((_) async => Right(tNumberTriva));
        //assert later
        final expected = [Empty(), Loading(), Loaded(tNumberTriva)];
        expectLater(bloc.stream, emitsInOrder(expected));
        //act
        bloc.add(GetTriviaFromConcreteNumber(numberString: tNumberString));
      },
    );
    test('should emit [Loading, Error] when getting fails', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(
        mockGetConcreteNumberTrivia(any),
      ).thenAnswer((_) async => Left(ServerFailure()));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        Error(errorMessege: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaFromConcreteNumber(numberString: tNumberString));
    });
    test(
      'should emit [Loading, Error] with a proper messege for error when getting data fails',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        when(
          mockGetConcreteNumberTrivia(any),
        ).thenAnswer((_) async => Left(CacheFailure()));
        //assert later
        final expected = [
          Empty(),
          Loading(),
          Error(errorMessege: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        //act
        bloc.add(GetTriviaFromConcreteNumber(numberString: tNumberString));
      },
    );
  });
  group('getRandomNumberTrivia', () {
    final tNumber = 1;
    final tNumberTrivia = NumberTrivia(text: 'test Trivia', number: tNumber);
    test('should get data from the random use case', () async {
      //arrange
      when(
        mockGetRandomNumberTrivia(any),
      ).thenAnswer((_) async => Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaFromRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      //assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });
    test(
      'should emit [Empty, loading, Loaded] when data is gotten successfully',
      () async {
        //arrange
        when(
          mockGetRandomNumberTrivia(any),
        ).thenAnswer((_) async => Right(tNumberTrivia));
        //assert
        final expected = [Empty(), Loading(), Loaded(tNumberTrivia)];
        expectLater(bloc.stream, emitsInOrder(expected));
        //act
        bloc.add(GetTriviaFromRandomNumber());
      },
    );
    test('should emit [Loading, Error] when getting data fails', () async {
      //arrange
      when(
        mockGetRandomNumberTrivia(any),
      ).thenAnswer((_) async => Left(ServerFailure()));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        Error(errorMessege: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaFromRandomNumber());
    });
    test(
      'should emit [Loading, Error] with a proper messege for error when getting data fails',
      () async {
        //arrange
        when(
          mockGetRandomNumberTrivia(any),
        ).thenAnswer((_) async => Left(CacheFailure()));
        //assert later
        final expected = [
          Empty(),
          Loading(),
          Error(errorMessege: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        //act
        bloc.add(GetTriviaFromRandomNumber());
      },
    );
  });
}
